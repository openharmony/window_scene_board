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

import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { AbstractInitialAble } from '../base/AbstractInitialAble';
import { RemoteLockStateManager } from '../manager/RemoteLockStateManager';
import { CameraStateManager } from '../manager/CameraStateManager';
import { FrequentFoldManager } from '../manager/FrequentFoldManager';
import { SystemSwitchUtils } from '../utils/SystemSwitchUtils';
import { SLAutoTestService } from './autoTest/SLAutoTestService';
import { ScreenLockUnlockService } from './ScreenLockUnLockService';
import { ScreenLockVerifyService, VerifyInterceptor } from './ScreenLockVerifyService';
import { ScreenOnOffService } from './ScreenOnOffService';
import { SimCardVerifyService } from './SimCardVerifyService';
import { UserSwitchService } from './UserSwitchService';
import { PasswordManager } from '../manager/PasswordManager';
import { CommonPwdInterceptor } from './VerifyInterceptor';
import { ScreenLockDebugCommand } from '../debug/ScreenLockDebugCommand';
import { ScreenLockVerifyDebugCommand } from '../debug/ScreenLockVerifyDebugCommand';
import { ThermalStateManager } from '../manager/ThermalStateManager';

const TAG = 'ScreenLockSetUpService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 屏幕启动服务（职责：公共服务层以及Model层的初始化）
 */
export class ScreenLockSetUpService extends AbstractInitialAble {
  private static sInstance: ScreenLockSetUpService;

  public static getInstance(): ScreenLockSetUpService {
    if (ScreenLockSetUpService.sInstance == null) {
      ScreenLockSetUpService.sInstance = new ScreenLockSetUpService();
    }
    return ScreenLockSetUpService.sInstance;
  }

  private readonly _initialServices: AbstractInitialAble[] = [
    RemoteLockStateManager.getInstance(),
    ScreenLockVerifyService.getInstance(),
    ScreenOnOffService.getInstance(),
    SimCardVerifyService.getInstance(),
    ScreenLockUnlockService.getInstance(),
    UserSwitchService.getInstance(),
    FrequentFoldManager.getInstance(),
    CameraStateManager.getInstance(),
    PasswordManager.getInstance(),
    ThermalStateManager.getInstance(),
  ];

  /**
   * 增加拦截器处理，此处可根据不同产品形态进行定制
   */
  private readonly _initialInterceptors: VerifyInterceptor[] = [
    new CommonPwdInterceptor()
  ];

  private readonly _initialDebugCommands: ScreenLockDebugCommand[] = [
    new ScreenLockVerifyDebugCommand(),
  ];

  private constructor() {
    super();
  }

  protected doInit(): void {
    log.showInfo('doInit');
    Trace.start(Trace.CORE_METHOD_LOCK_SERVICE_INIT);

    // 标记使用重构后的锁屏，注：当前PC暂未切换新逻辑，因此使用此开关进行隔离，避免影响其逻辑
    SystemSwitchUtils.setUseNewScreenLock();

    // 初始化公共服务
    this._initialServices.forEach(service => service.init());

    // 初始化验证服务的拦截器
    this._initialInterceptors.forEach(interceptor => {
      interceptor.init();
      ScreenLockVerifyService.getInstance().registerInterceptor(interceptor);
    });

    this._initialDebugCommands.forEach(debugCommand => debugCommand.init());

    SLAutoTestService.getInstance().startService();

    Trace.end(Trace.CORE_METHOD_LOCK_SERVICE_INIT);
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    this._initialServices.forEach(service => service.release());
    this._initialInterceptors.forEach(interceptor => {
      interceptor.release();
      ScreenLockVerifyService.getInstance().unRegisterInterceptor(interceptor);
    });
    SLAutoTestService.getInstance().stopService();
  }
}