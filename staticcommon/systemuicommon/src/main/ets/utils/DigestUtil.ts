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

import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';

const TAG = 'SysUI_SummaryUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 信息摘要 工具类
 */
export class DigestUtil {
  // 摘要算法
  public static readonly DIGEST_ALGORITHM = 'SHA512';

  private static async getDigest(data: Uint8Array): Promise<string> {
    const md = cryptoFramework.createMd(DigestUtil.DIGEST_ALGORITHM);
    await md.update({ data: data });
    const result = await md.digest();
    const hex = result.data.reduce((str, byte) => str + byte.toString(16).padStart(2, '0'), '');
    return hex;
  }

  public static async getDigestByString(text?: string): Promise<string> {
    if (!text) {
      return '';
    }
    let result = '';
    try {
      TraceUtil.startTrace(DomainName.SYS_UI, 'Digest');
      result = await this.getDigest(new Uint8Array(buffer.from(text).buffer));
      TraceUtil.endTrace(DomainName.SYS_UI, 'Digest');
    } catch (e) {
      log.warn('getDigestByString fail: ', e);
    }
    return result;
  }
}