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

import {
  FormCenterViewParam,
  FormDisplayType,
  FormCenterLocation
} from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { FormManagerEventInterface } from '../../../interfaces/FormManagerEventInterface';
import { SwiperLayoutEventInterface } from '../../../interfaces/SwiperLayoutEventInterface';
import { SwiperScreenLockViewEvent } from '../swiperlayoutevent/SwiperScreenLockEvent';
import { FormManagerEvent } from './FormManagerEvent';

export class ScreenLockFormManagerEvent extends FormManagerEvent implements FormManagerEventInterface {
  onDetentsDidChange(height: number): void {
    this.mViewStateChangeCallback?.onHeightChange?.();
  }

  getSwiperLayoutEvent(): SwiperLayoutEventInterface {
    return new SwiperScreenLockViewEvent(this.mSwiperLayoutData, this.mViewData, this.mAppInfo);
  }

  protected getFormCenterViewParam(): FormCenterViewParam {
    let param: FormCenterViewParam = super.getFormCenterViewParam();
    param.formDisplayType = FormDisplayType.SCREEN_LOCK_CARD;
    param.location = FormCenterLocation.SCREEN_LOCK;
    return param;
  }
}