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
import { AbstractObserverManager, VerifyDataManager } from '@ohos/screenlockcommon';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';

const TAG = 'VerifyTipsService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 验证提示信息
 */
export class VerifyResultInfo {
  /**
   * 密码验证是否冻结
   */
  public isPwdFreezing: boolean = false;

  /**
   * 剩余验证次数
   */
  public remainTimes: number = 5;

  /**
   * 冻结时间
   */
  public freezingTime: number = 0;

  public toString(): string {
    return `isPwdFreezing:${this.isPwdFreezing}, remainTimes:${this.remainTimes}, freezingTime:${this.freezingTime}`;
  }
}

/**
 * 验证提示监听器
 */
export interface VerifyTipsListener {
  /**
   * 验证中提示
   *
   * @param 验证类型
   * @param acquire 提示信息
   */
  onVerifyingTips?: (authType: AuthType, acquire: number) => void;

  /**
   * 验证结果提示
   *
   * @param authType 验证类型
   * @param verifyResultInfo 验证结果
   */
  onVerifyResultTips?: (authType: AuthType, verifyResultInfo: VerifyResultInfo) => void;
}

/**
 * 验证提示服务
 */
export class VerifyTipsService extends AbstractObserverManager<VerifyTipsListener> {
  private static sInstance: VerifyTipsService;

  public static getInstance(): VerifyTipsService {
    if (!VerifyTipsService.sInstance) {
      VerifyTipsService.sInstance = new VerifyTipsService();
    }
    return VerifyTipsService.sInstance;
  }

  private constructor() {
    super();
  }

  /**
   * 发布验证中提示
   *
   * @param 验证类型
   * @param acquire 提示信息
   */
  public publishVerifyingTips(authType: AuthType, acquire: number): void {
    log.showInfo(`publishVerifyingTips authType: ${AuthType[authType]}, acquire: ${acquire}`);
    this.broadcastDataChange(observer => observer.onVerifyingTips?.(authType, acquire));
  }

  /**
   * 发布验证结果提示
   */
  public publishVerifyResultTips(authType: AuthType, verifyResultInfo?: VerifyResultInfo): void {
    log.showInfo(`publishVerifyResultTips authType: ${AuthType[authType]}.`);
    this.broadcastDataChange(observer => observer.onVerifyResultTips?.(authType,
      verifyResultInfo ?? this.generateVerifyResult(authType)));
  }

  private generateVerifyResult(authType: AuthType): VerifyResultInfo {
    let verifyResultInfo: VerifyResultInfo = new VerifyResultInfo();
    verifyResultInfo.isPwdFreezing = VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN).isStateLocked;
    verifyResultInfo.remainTimes = VerifyDataManager.getInstance().getVerifyInfo(authType).remainTimes;
    verifyResultInfo.freezingTime = VerifyDataManager.getInstance()
      .getVerifyInfo(verifyResultInfo.isPwdFreezing ? AuthType.PIN : authType).freezingTime;
    return verifyResultInfo;
  }
}