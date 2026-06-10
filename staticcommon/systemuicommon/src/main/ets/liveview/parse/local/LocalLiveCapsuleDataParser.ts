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
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/commonconstants';
import type NtfMgr from '@ohos.notificationManager';
import { CapsuleType } from '../../common/LiveConstants';
import { LiveCapsuleData } from '../../data/capsule/LiveCapsuleData';
import type { Parse } from '../interface/Parse';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'LocalLiveCapsuleDataParser';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 本地系统应用实况通知胶囊解析器
 */
export class LocalLiveCapsuleDataParser implements Parse<LiveCapsuleData> {
  /**
   * 解析胶囊数据
   *
   * @param request 实况请求
   * @returns 胶囊数据
   */
  parse(request: NtfMgr.NotificationRequest): LiveCapsuleData | undefined {
    let capsuleData = request.content.systemLiveView.capsule;
    if (CommonUtils.isInvalid(capsuleData)) {
      log.showError('capsule data is Invalid');
      return undefined;
    }
    let capsule: LiveCapsuleData = new LiveCapsuleData();
    capsule.setBundleName(request.creatorBundleName);
    capsule.setUid(request.creatorUid);
    capsule.setHashCode(request.hashCode);
    capsule.setCapsuleTitle(capsuleData.title);
    capsule.setCapsuleIcon(capsuleData.icon);
    capsule.setBackgroundColor(capsuleData.backgroundColor);
    capsule.setCapsuleType(this.readCapsuleType(request));
    capsule.setCapsuleTypeCode(request?.content?.systemLiveView?.typeCode);
    log.showInfo(capsule.toString());
    return capsule;
  }

  /**
   * 获取当前胶囊的类型
   *
   * @param request 实况请求
   * @returns 胶囊类型
   */
  private readCapsuleType(request: NtfMgr.NotificationRequest): CapsuleType {
    if (request.content.systemLiveView.time) {
      return CapsuleType.TYPE_TIMER;
    }
    if (request.content.systemLiveView.progress) {
      return CapsuleType.TYPE_PROGRESS;
    }
    return CapsuleType.TYPE_TEXT;
  }
}