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

import hiSysEvent from '@ohos.hiSysEvent';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  HiDfxEventUtil,
  ReportParams,
  ScreenUnlockEventParams
} from '@ohos/frameworkwrapper';
import { ScreenLockStateManager } from '../../manager/ScreenLockStateManager';
import { VerifyDataManager } from '../../manager/VerifyDataManager';
import { AccountHelper, AuthSubType, AuthType } from '../../utils/AccountHelper';
import { PowerUtils } from '../../utils/PowerUtils';
import { HiKGReportBase } from './PerformanceMonitorUtil';

const TAG = 'SlUnlockReportHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const SCREEN_UNLOCK_EVENT: string = 'SCREENUNLOCK_EVENT';
const MAIN_USER_ID: number = 100;

/**
 * 解锁类型
 */
enum UnlockType {
  /**
   * 滑动解锁
   */
  FLING = 'FLING',

  /**
   * 人脸解锁
   */
  FACIAL = 'FACIAL',

  /**
   * 指纹解锁
   */
  FINGERPRINT = 'FINGERPRINT',

  /**
   * 密码解锁
   */
  PASSWORD = 'PASSWORD'
}

/**
 * 解锁流程时间记录
 */
class UnlockFlowTimeRecord {
  public startUnlock: number = 0;
  public startAuth: number = 0;
  public endAuth: number = 0;
  public endUnlock: number = 0;
  public authTime: number = 0;
  public unlockTime: number = 0;
}

/**
 * 解锁上报辅助类
 */
export class SlUnlockReportHelper {
  private static sInstance: SlUnlockReportHelper;

  public static getInstance(): SlUnlockReportHelper {
    if (SlUnlockReportHelper.sInstance == null) {
      SlUnlockReportHelper.sInstance = new SlUnlockReportHelper();
    }
    return SlUnlockReportHelper.sInstance;
  }

  private readonly unlockFlowTimeMap: Map<UnlockType, UnlockFlowTimeRecord> = new Map();

  private constructor() {
    this.unlockFlowTimeMap.set(UnlockType.FLING, new UnlockFlowTimeRecord());
    this.unlockFlowTimeMap.set(UnlockType.FACIAL, new UnlockFlowTimeRecord());
    this.unlockFlowTimeMap.set(UnlockType.FINGERPRINT, new UnlockFlowTimeRecord());
    this.unlockFlowTimeMap.set(UnlockType.PASSWORD, new UnlockFlowTimeRecord());
  }

  /**
   * 记录解锁开始时间
   *
   * @param authType 解锁类型
   */
  public recordUnlockStartTime(authType: number = 0): void {
    let timeRecord: UnlockFlowTimeRecord | undefined = this.unlockFlowTimeMap.get(this.getUnlockType(authType));
    if (timeRecord) {
      timeRecord.startUnlock = new Date().getTime();
      log.showInfo(`recordUnlockStartTime, authType: ${authType}, startUnlock: ${timeRecord.startUnlock}`);
    }
  }

  /**
   * 记录验证开始时间
   */
  public recordAuthStartTime(authType: number = 0): void {
    let timeRecord: UnlockFlowTimeRecord | undefined = this.unlockFlowTimeMap.get(this.getUnlockType(authType));
    if (timeRecord) {
      timeRecord.startAuth = new Date().getTime();
      log.showInfo(`recordAuthStartTime, authType: ${authType}, startAuth: ${timeRecord.startAuth}`);
    }
  }

  /**
   * 记录验证结束时间
   */
  public recordAuthEndTime(authType: number = 0): void {
    let timeRecord: UnlockFlowTimeRecord | undefined = this.unlockFlowTimeMap.get(this.getUnlockType(authType));
    if (timeRecord) {
      timeRecord.endAuth = new Date().getTime();
      log.showInfo(`authType: ${authType}, endTime: ${timeRecord.endAuth}`);
    }
  }

  /**
   * 解锁事件打点
   *
   * @param authType 验证类型
   * @param isVerifySuccess 解锁成功
   */
  public unlockReport(authType: number = 0, isVerifySuccess: boolean = true): void {
    const unlockType: UnlockType = this.getUnlockType(authType);
    let timeRecord: UnlockFlowTimeRecord | undefined = this.unlockFlowTimeMap.get(unlockType);
    if (timeRecord) {
      timeRecord.endUnlock = new Date().getTime();
      timeRecord.authTime = timeRecord.endAuth - timeRecord.startAuth;
      timeRecord.unlockTime = timeRecord.endUnlock - timeRecord.startUnlock;
    }
    log.showInfo(`unlockReport authType: ${authType}, isVerifySuccess: ${isVerifySuccess}`);

    let params: ScreenUnlockEventParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      VERIFYSUCESS: isVerifySuccess,
      VERIFY_COSTTIME: timeRecord?.authTime,
      E2E_LATENCY: timeRecord?.unlockTime,
      TYPE: this.getReportUnlockType(authType, unlockType),
      FACIALMETHOD: this.getFacialMethod(),
      SCREENSTATE: this.getScreenState(unlockType),
      PWDUI: this.getPwdUi(unlockType),
      SWITCHMODE: this.getUserSwitchMode(),
    };
    HiKGReportBase.reportUe(SCREEN_UNLOCK_EVENT, params);

    if (unlockType === UnlockType.FLING) {
      log.showInfo(`unlock type(${unlockType}), so do report no pwd unlock `);
      HiDfxEventUtil.reportNoPwdUnlock();
    }
  }

  private getUnlockType(authType: number): UnlockType {
    switch (authType) {
      case AuthType.PIN:
      case AuthType.DOMAIN:
        return UnlockType.PASSWORD;
      case AuthType.FACE:
        if (!VerifyDataManager.getInstance().getVerifyInfo(authType)?.isDirectUnlock) {
            return UnlockType.FLING;
        }
        return UnlockType.FACIAL;
      case AuthType.FINGERPRINT:
        return UnlockType.FINGERPRINT;
      default:
        return UnlockType.FLING;
    }
  }

  private getScreenState(unlockType: UnlockType): string | undefined {
    if (unlockType === UnlockType.FINGERPRINT) {
      return PowerUtils.isActive() ? 'on' : 'off';
    }
    return undefined;
  }

  private getReportUnlockType(authType: AuthType, unlockType: UnlockType): string {
    if (unlockType === UnlockType.PASSWORD) {
      return AuthSubType[VerifyDataManager.getInstance().getVerifyInfo(authType).authSubType] ?? '';
    }
    return unlockType;
  }

  private getFacialMethod(): number {
    return VerifyDataManager.getInstance().getVerifyInfo(AuthType.FACE).isDirectUnlock ? 1 : 0;
  }

  private getPwdUi(unlockType: UnlockType): string | undefined {
    if (unlockType === UnlockType.FINGERPRINT || unlockType === UnlockType.FACIAL) {
      return ScreenLockStateManager.getInstance().isInBouncer ? 'IN_PWDUI' : 'NO_PWDUI';
    }
    return undefined;
  }

  private getUserSwitchMode(): string {
    return AccountHelper.getInstance().currentLocalId === MAIN_USER_ID ? 'toMain' : 'toPrivacy';
  }
}