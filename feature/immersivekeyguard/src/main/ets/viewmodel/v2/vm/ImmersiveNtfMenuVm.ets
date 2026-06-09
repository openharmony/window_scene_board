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

import { NotificationMenuVm } from '@ohos/notificationcomponent/newIndex';
import { IImmersiveNtfMenuVm } from '../../../common/interface/IImmersiveNtfMenuVm';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';

const STATUS_BAR_HEIGHT = ResUtils.getNumberFromLength($r('app.float.status_bar_phone_height'));

/**
 * 沉浸列表条目菜单按钮业务管理
 */
@ObservedV2
export class ImmersiveNtfMenuVm extends NotificationMenuVm implements IImmersiveNtfMenuVm {
  protected getSettingBtnTranslateY(): number {
    return STATUS_BAR_HEIGHT;
  }
}