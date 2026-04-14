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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { UIContext } from '@kit.ArkUI';

const TAG = 'FocusUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 焦点工具类
 */
export class FocusUtil {
  /**
   * 通过组件的id将焦点转移到组件树对应的实体节点,当前帧生效
   *
   * @param uiContext
   * @param focusId  组件ID
   */
  public static requestFocus(uiContext: UIContext, focusId: string): void {
    try {
      uiContext.getFocusController().requestFocus(focusId);
    } catch (error) {
      log.warn(`requestFocus failed focusId: ${focusId}, code is ${error.code} , message is ${error.message}`);
    }
  }

  /**
   * 通过组件的id将焦点转移到组件树对应的实体节点,下一帧生效
   *
   * @param focusId 组件ID
   * @returns true:设置焦点成功
   */
  public static requestFocusNextFrame(focusId?: string): boolean {
    let requestResult: boolean = focusControl.requestFocus(focusId);
    log.info(`requestFocusNextFrame focusId: ${focusId}, res is ${requestResult}`);
    return requestResult;
  }
}