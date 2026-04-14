/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// 沉浸模块拦截器名
export enum InterruptName {
  NTF_DATA_CHANGE = 'ntf_data_change', // 通知列表数据更新拦截器
  NTF_ITEM_ANIM_PARAS = 'ntf_item_anim_paras', // 通知列表堆叠动效刷新拦截器
  ANIM_CAP_TO_LIST = 'anim_cap_to_list', // 胶囊过渡列表动效拦截器
  ITEM_HEIGHT_MESH = 'item_height_mesh', // 列表item高度切换时栅格刷新拦截器
  CARD_DATA_CHANGE = 'card_data_change', // 沉浸卡片数据更新拦截器
  ANIM_LIST_CARD = 'anim_list_to_card', // 列表过渡大卡finish拦截器
}