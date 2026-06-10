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

import { UIExtensionContentSession } from '@kit.AbilityKit';
import { LogDomain, Logger } from '@ohos/basicutils';

const TAG = 'AlertViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
export interface AlertViewModelParams {
  // 弹框标题
  title: string;
  // 弹框内容
  content: string;
  // 弹框按钮
  button: string;
}

export class AlertViewModel {
  private session: UIExtensionContentSession;
  private params: AlertViewModelParams;

  constructor(session: UIExtensionContentSession, params: AlertViewModelParams, ) {
    log.showInfo(TAG, `title: ${params?.title}, content: ${params?.content}, btn: ${params?.button}`);
    this.params = params;
    this.session = session;
  }

  public terminateSession(): void {
    try {
      this.session?.terminateSelf();
      log.showInfo(TAG, 'terminateSelf success');
    } catch (err) {
      log.showError(TAG, `terminateSelf err: ${err}`);
    }
  }

  public getDialogTitle(): string {
    return this.params?.title;
  }

  public getDialogContent(): string {
    return this.params?.content;
  }

  public getBtnValue(): string {
    return this.params?.button;
  }
}