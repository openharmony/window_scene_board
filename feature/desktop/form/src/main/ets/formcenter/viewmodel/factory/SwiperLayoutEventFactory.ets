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

import { AppItemInfo, CommonConstants } from '@ohos/launchercommon';
import { FormCenterViewModel } from '../FormCenterViewModel';
import { SwiperLayoutViewData } from '../data/SwiperLayoutViewData';
import { NavDestinationViewData } from '../../../default/viewmodel/FormCenterObservedData';
import { SwiperLayoutEventInterface } from '../../interfaces/SwiperLayoutEventInterface';
import { SwiperScreenLockViewEvent } from '../event/swiperlayoutevent/SwiperScreenLockEvent';
import { SwiperLayoutEvent } from '../event/swiperlayoutevent/SwiperLayoutEvent';

interface SwiperLayoutEventParam {
  swiperLayoutViewData: SwiperLayoutViewData,
  mViewData: NavDestinationViewData,
  appInfo: AppItemInfo,
}

export class SwiperLayoutEventFactory {
  public static createSwiperLayOutEvent(param: SwiperLayoutEventParam): SwiperLayoutEventInterface {
    if (FormCenterViewModel.getInstance().isScreenLock) {
      return new SwiperScreenLockViewEvent(param.swiperLayoutViewData, param.mViewData, param.appInfo);
    }
    return new SwiperLayoutEvent(param.swiperLayoutViewData, param.mViewData, param.appInfo);
  }
}