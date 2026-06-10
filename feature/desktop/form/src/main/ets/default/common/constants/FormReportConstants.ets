/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

export const enum FormReportConstants {
  // 一天的毫秒数
  ONE_DAY_MILL = 86400000,

  // 一个小时的毫秒数
  ONE_HOUR_MILL = 3600000,

  // 一分钟的毫秒数
  ONE_MINUTE_MILL = 60000,

  // 一秒的毫秒数
  ONE_SECOND_MILL = 1000,

  // 一周的天数，从0算起
  ONE_WEEK_DAYS = 6,

  // 曝光次数上报值
  EXPOSURE_MAX_TIME = 30,
};

/**
 * 锁屏编辑拖拽添加卡片
 */
export const SCREEN_LOCK_EDIT_CARD_ADD_DRAG = 'SCREEN_LOCK_EDIT_CARD_ADD_DRAG';