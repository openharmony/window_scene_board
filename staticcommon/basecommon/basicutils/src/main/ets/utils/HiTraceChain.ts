/*
 * Copyright (c) 2025-2025 Huawei Device Co., Ltd.
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

import hiTraceChain from '@ohos.hiTraceChain';

/**
 * HiTraceChain Proxy
 */
export class HiTraceChain {
  private traceTag: string;
  private curTraceId: hiTraceChain.HiTraceId;
  private isTraceIdValid: boolean;

  public constructor(traceTag: string) {
    this.traceTag = traceTag;
    this.curTraceId = hiTraceChain.getId();
    this.isTraceIdValid = hiTraceChain.isValid(this.curTraceId);
  }

  /**
   * begin hiTraceChain
   */
  public begin(): void {
    if (!this.isTraceIdValid) {
      this.curTraceId = hiTraceChain.begin(this.traceTag,
        hiTraceChain.HiTraceFlag.NO_BE_INFO |
        hiTraceChain.HiTraceFlag.DONOT_CREATE_SPAN);
    }
  }

  /**
   * end hiTraceChain
   */
  public end(): void {
    if (!this.isTraceIdValid) {
      hiTraceChain.end(this.curTraceId);
    }
  }
}