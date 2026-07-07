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

import { ButtonOptions } from '@kit.ArkUI';
import { AppToHapMappingManager, InstalledDialogType } from '../base/AppToHapMappingManager';

export class DeliverDialogUtil {
  /**
   * 构建更新弹框按钮
   *
   * @param bundleName 应用包名
   * @param text 内容
   * @param onClick action
   * @returns 更新弹框按钮
   */
  public static createDialogPrimaryButton(bundleName: string, text: Resource | undefined,
    onClick: () => void): ButtonOptions | undefined {
    if (AppToHapMappingManager.getInstance().isForceUpdate(bundleName)) {
      return undefined;
    }
    if (text === undefined) {
      return undefined;
    }
    return {
      value: text,
      action: onClick
    };
  }

  /**
   * 构建卸载弹框按钮
   *
   * @param installedDialogType 弹框类型
   * @param text 内容
   * @param onClick action
   * @returns 卸载弹框按钮
   */
  public static createUninstallDialogPrimaryButton(installedDialogType: InstalledDialogType, text: Resource | undefined,
    onClick: () => void): ButtonOptions | undefined {
    if (installedDialogType && installedDialogType === InstalledDialogType.FORCE_UNINSTALL) {
      return undefined;
    }
    if (text === undefined) {
      return undefined;
    }
    return {
      value: text,
      action: onClick
    };
  }
}