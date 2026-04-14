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

import { ViewCallback } from '@ohos/frameworkwrapper';
import { FrameCount } from '@ohos/systemuicommon';
import { launcherStatusUtil } from '@ohos/windowscene';
import {
  FormCenterViewParam,
  FormDisplayType,
} from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { NavDestinationViewData } from '../../../default/viewmodel/FormCenterObservedData';
import { FormManagerEventInterface } from '../../interfaces/FormManagerEventInterface';
import { BindSheetStateData } from '../data/BindSheetStateData';
import { SwiperLayoutViewData } from '../data/SwiperLayoutViewData';
import { FormManagerEvent } from '../event/FormManagerEvent/FormManagerEvent';
import lazy { OuterFormManagerEvent } from '../event/FormManagerEvent/OuterFormManageEvent';
import { ScreenLockFormManagerEvent } from '../event/FormManagerEvent/ScreenLockFormManageEvent';

interface FormManagerEventParam {
  formCenterViewParam: FormCenterViewParam,
  mViewData: NavDestinationViewData,
  bindSheetStateData: BindSheetStateData,
  swiperLayoutData: SwiperLayoutViewData,
  mViewStateChangeCallback?: ViewCallback,
  frameCount?: FrameCount,
}

export class FormManagerEventFactory {
  public static createFormManagerEvent(param: FormManagerEventParam): FormManagerEventInterface {
    if (param.formCenterViewParam.formDisplayType === FormDisplayType.SCREEN_LOCK_CARD) {
      return new ScreenLockFormManagerEvent(param.formCenterViewParam, param.mViewData,
        param.bindSheetStateData, param.swiperLayoutData, param.mViewStateChangeCallback);
    }

    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return new OuterFormManagerEvent(param.formCenterViewParam, param.mViewData,
        param.bindSheetStateData, param.swiperLayoutData, param.mViewStateChangeCallback);
    }

    return new FormManagerEvent(param.formCenterViewParam, param.mViewData,
      param.bindSheetStateData, param.swiperLayoutData, param.mViewStateChangeCallback);
  }
}