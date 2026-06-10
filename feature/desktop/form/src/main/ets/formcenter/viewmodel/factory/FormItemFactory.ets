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

import { CardItemInfo, CommonConstants } from '@ohos/launchercommon';
import { CheckEmptyUtils } from '@ohos/basicutils';
import ScreenLockForm from '../../view/atomicview/formitem/ScreenLockForm';
import DesktopForm from '../../view/atomicview/formitem/CommonForm';
import ShortcutForm from '../../view/atomicview/formitem/ShortcutForm';
import { FormItemBuilderInterface } from '../../interfaces/FormItemBuilderInterface';
import { FormCenterViewModel } from '../FormCenterViewModel';

interface FormTypeParam {
  formItem: CardItemInfo;
}

export class FormItemFactory {
  public static createFormItem(param: FormTypeParam): FormItemBuilderInterface {
    if (FormCenterViewModel.getInstance().isScreenLock) {
      return new ScreenLockForm();
    }
    // 卡片管理快捷方式
    if (!CheckEmptyUtils.isEmpty(param.formItem.shortcutInfo)) {
      return new ShortcutForm();
    }
    return new DesktopForm();
  }
}