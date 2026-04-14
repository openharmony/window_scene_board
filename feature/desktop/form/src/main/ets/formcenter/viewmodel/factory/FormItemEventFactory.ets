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

import { CardItemInfo, CommonConstants } from '@ohos/launchercommon';
import { NavDestinationViewData } from '../../../default/viewmodel/FormCenterObservedData';
import { FormCenterViewModel } from '../FormCenterViewModel';
import { FormItemEventInterface } from '../../interfaces/FormItemEventInterface';
import { TileFormItemEvent } from '../event/FormItemEvent/TileFormItemEvent';
import { TileScreenLockFormItemEvent } from '../event/FormItemEvent/TileScreenLockFormItemEvent';

interface FormItemEventParam {
  viewData: NavDestinationViewData,
  formItem: CardItemInfo;
  index: number;
}

export class FormItemEventFactory {
  public static createFormItemEvent(param: FormItemEventParam): FormItemEventInterface {
    if (FormCenterViewModel.getInstance().isScreenLock) {
      return new TileScreenLockFormItemEvent(param.viewData, param.formItem, param.index);
    }
    return new TileFormItemEvent(param.viewData, param.formItem, param.index);
  }
}