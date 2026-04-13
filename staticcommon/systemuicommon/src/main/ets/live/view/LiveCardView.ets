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

import { LiveNotification } from '../model/LiveNotification';
import { LiveCardSystemView } from './LiveCardSystemView';
import { LiveCardOtherView } from './LiveCardOtherView';
import { LiveCardNavigationView } from './LiveCardNavigationView';
import { LiveCardMediaPlayerView } from './LiveCardMediaPlayerView';

export interface LiveCardViewParams {
  /**
   * 实况数据
   */
  live: LiveNotification;
}

@Builder
export function LiveCardView($$: LiveCardViewParams) {
  if ($$.live?.card) {
    if ($$.live?.isMediaPlayer?.()) {
      LiveCardMediaPlayerView({
        live: $$.live,
      })
    } else if ($$.live.card?.isSystemCard?.()) {
      LiveCardSystemView({
        live: $$.live,
      })
    } else if ($$.live.card?.isNavigationCard?.()) {
      LiveCardNavigationView({
        live: $$.live,
      })
    } else {
      LiveCardOtherView({
        live: $$.live,
      })
    }
  }
}