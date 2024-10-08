/*
 * SPDX-FileCopyrightText: Copyright (c) 2020 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 * SPDX-License-Identifier: LicenseRef-NvidiaProprietary
 *
 * NVIDIA CORPORATION, its affiliates and licensors retain all intellectual
 * property and proprietary rights in and to this material, related
 * documentation and any modifications thereto. Any use, reproduction,
 * disclosure or distribution of this material and related documentation
 * without an express license agreement from NVIDIA CORPORATION or
 * its affiliates is strictly prohibited.
 */

#include <gst/gst.h>
#include <glib.h>
#include <iostream>
#include <vector>
#include <unordered_map>
#include <sstream>
#include "gstnvdsmeta.h"
#include "nvds_analytics_meta.h"

/* parse_nvdsanalytics_meta_data
 * and extract nvanalytics metadata etc. */
extern "C" void
parse_nvdsanalytics_meta_data (NvDsBatchMeta *batch_meta)
{
    NvDsObjectMeta *obj_meta = NULL;
    NvDsMetaList * l_frame = NULL;
    NvDsMetaList * l_obj = NULL;

    //NvDsBatchMeta *batch_meta = gst_buffer_get_nvds_batch_meta (buf);

    for (l_frame = batch_meta->frame_meta_list; l_frame != NULL;
            l_frame = l_frame->next) {
        NvDsFrameMeta *frame_meta = (NvDsFrameMeta *) (l_frame->data);
        std::stringstream out_string;
        /* Iterate user metadata in frames to search analytics metadata */
        for (NvDsMetaList * l_user = frame_meta->frame_user_meta_list;
                l_user != NULL; l_user = l_user->next) {
            NvDsUserMeta *user_meta = (NvDsUserMeta *) l_user->data;
            if (user_meta->base_meta.meta_type != NVDS_USER_FRAME_META_NVDSANALYTICS)
                continue;

            /* convert to  metadata */
            NvDsAnalyticsFrameMeta *meta =
                (NvDsAnalyticsFrameMeta *) user_meta->user_meta_data;
            /* Get the labels from nvdsanalytics config file */
            for (std::pair<std::string, uint32_t> status : meta->objInROIcnt){
                out_string << " Objs in ROI ";
                out_string << status.first;
                out_string << " = ";
                out_string << status.second;
            }
            for (std::pair<std::string, uint32_t> status : meta->objLCCumCnt){
                out_string << " LineCrossing Cumulative ";
                out_string << status.first;
                out_string << " = ";
                out_string << status.second;
            }
            for (std::pair<std::string, uint32_t> status : meta->objLCCurrCnt){
                out_string << " LineCrossing Current Frame ";
                out_string << status.first;
                out_string << " = ";
                out_string << status.second;
            }
            for (std::pair<std::string, bool> status : meta->ocStatus){
                out_string << " Overcrowding status ";
                out_string << status.first;
                out_string << " = ";
                out_string << status.second;
            }
        }
        for (l_obj = frame_meta->obj_meta_list; l_obj != NULL;
                l_obj = l_obj->next) {
            obj_meta = (NvDsObjectMeta *) (l_obj->data);

            // Access attached user meta for each object
            for (NvDsMetaList *l_user_meta = obj_meta->obj_user_meta_list; l_user_meta != NULL;
                    l_user_meta = l_user_meta->next) {
                NvDsUserMeta *user_meta = (NvDsUserMeta *) (l_user_meta->data);
                if(user_meta->base_meta.meta_type == NVDS_USER_OBJ_META_NVDSANALYTICS)
                {
                    NvDsAnalyticsObjInfo * user_meta_data =
                        (NvDsAnalyticsObjInfo *)user_meta->user_meta_data;
                    if (user_meta_data->dirStatus.length()){
                        out_string << " object " << obj_meta->object_id <<
                            " is moving in " <<  user_meta_data->dirStatus;
                    }
                }
            }
        }


        if (out_string.str().size()){
            g_print ("Frame Number = %d of Stream = %d,  %s\n",
                    frame_meta->frame_num, frame_meta->pad_index,
                    out_string.str().c_str());
        }
    }
}


