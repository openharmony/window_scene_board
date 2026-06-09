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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { TimeoutPromise } from '../base/common/TimeoutProimse';

const TAG = 'OverlayAnimGuarantee';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 一镜到底保底者
 */
class OverlayAnimGuarantee {
  /**
   * 超时保底时间
   */
  public static readonly GUARANTEE_TIMEOUT = 400;

  private entryId: string = '';
  private guarantee?: TimeoutPromise<void>;

  public init(entryId: string, guarantee: TimeoutPromise<void>): void {
    this.entryId = entryId;
    this.guarantee = guarantee;
  }

  /**
   * 启动保底，只是开始保底操作的计时，计时达到后再执行具体的保底，并非立即执行保底操作
   */
  public start(): void {
    if (this.guarantee) {
      this.guarantee.startTimeout(OverlayAnimGuarantee.GUARANTEE_TIMEOUT);
    } else {
      log.showWarn('Start guarantee error for %{public}s by undefined guarantee.', this.entryId);
    }
  }

  public cancel(reason: string): void {
    log.showInfo('CancelGuarantee for %{public}s. exists %{public}s.', this.entryId, this.guarantee !== undefined);
    if (this.guarantee) {
      this.guarantee?.manuallyReject(reason);
    }
    // 及时清理防止内存泄露
    this.guarantee = undefined;
  }
}

let guarantee: OverlayAnimGuarantee = new OverlayAnimGuarantee();

export default guarantee as OverlayAnimGuarantee;