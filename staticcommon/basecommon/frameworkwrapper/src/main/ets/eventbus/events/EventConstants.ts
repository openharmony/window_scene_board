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

interface EventConstantsType {
  EVENT_FLOAT_ON_FOCUS: string;
  EVENT_IN_APP_EXIT: string;
}

/**
 * Constants of events that will be registered to system.
 */
export const EventConstants: EventConstantsType = {
  // float show events
  EVENT_FLOAT_ON_FOCUS: 'launcher.event.EVENT_FLOAT_ON_FOCUS',

  // 退出动效
  EVENT_IN_APP_EXIT: 'launcher.event.IN_APP_EXIT',
};