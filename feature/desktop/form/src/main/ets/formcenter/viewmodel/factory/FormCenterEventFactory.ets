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

import { DeviceHelper, ViewCallback } from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import {
  FormCenterViewParam, FormDisplayType,
} from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { LazyDataSource } from '@ohos/launchercommon/Index';
import { ViewData } from '../../../default/viewmodel/FormCenterObservedData';
import { BindSheetStateData } from '../data/BindSheetStateData';
import { FormCenterViewEvent } from '../event/FormCenterViewEvent/FormCenterViewEvent';
import lazy { OuterFormCenterViewEvent } from '../event/FormCenterViewEvent/OuterFormCenterViewEvent';
import { ScreenLockFormCenterEvent } from '../event/FormCenterViewEvent/ScreenLockFormCenterEvent';
import { AppItemInfo, CardItemInfo } from '@ohos/launchercommon';
import { FormCenterEventInterface } from '../../interfaces/FormCenterEventInterface';
import lazy { PcFormCenterEvent } from '../event/FormCenterViewEvent/PcFormCenterEvent';
import { NegativeScreenFormEvent } from '../event/FormCenterViewEvent/NegativeScreenFormEvent';

interface FormManagerEventParam {
  formCenterViewParam: FormCenterViewParam,
  mAppInfoList: LazyDataSource<AppItemInfo>,
  mRecommendedCardList: CardItemInfo[],
  mViewStateChangeCallback?: ViewCallback,
  bindSheetStateData: BindSheetStateData,
  mViewData: ViewData,
}

export class FormCenterEventFactory {
  public static createFormCenterEvent(param: FormManagerEventParam): FormCenterEventInterface {
    if (param.formCenterViewParam.formDisplayType === FormDisplayType.SCREEN_LOCK_CARD) {
      return new ScreenLockFormCenterEvent(param.mAppInfoList, param.mRecommendedCardList, param.bindSheetStateData,
        param.mViewData, param.mViewStateChangeCallback);
    }

    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return new OuterFormCenterViewEvent(param.mAppInfoList, param.mRecommendedCardList, param.bindSheetStateData,
        param.mViewData, param.mViewStateChangeCallback);
    }

    if (DeviceHelper.isPC()) {
      return new PcFormCenterEvent(param.mAppInfoList, param.mRecommendedCardList, param.bindSheetStateData,
        param.mViewData, param.mViewStateChangeCallback)
    }

    if (param.formCenterViewParam.isNegativeScreenOpen) {
      return new NegativeScreenFormEvent(param.mAppInfoList, param.mRecommendedCardList, param.bindSheetStateData,
        param.mViewData, param.mViewStateChangeCallback);
    }

    return new FormCenterViewEvent(param.mAppInfoList, param.mRecommendedCardList, param.bindSheetStateData,
      param.mViewData, param.mViewStateChangeCallback);
  }
}