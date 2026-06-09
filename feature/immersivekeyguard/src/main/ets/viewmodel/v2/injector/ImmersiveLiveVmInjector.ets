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

import { SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { LiveVmInjector, LiveItemBaseVm, ILiveStarterVm } from '@ohos/systemuicommon/newIndex';
import { SystemUIUseScene, LiveNotification } from '@ohos/systemuicommon/newTsIndex';
import { ImmStyleConfigH } from '../../../model/helper/ImmStyleConfigHelper';
import { IImmersiveLiveAuthorizationVm } from '../../../common/interface/IImmersiveLiveAuthorizationVm';
import { IImmersiveLiveCardOtherVm } from '../../../common/interface/IImmersiveLiveCardOtherVm';
import { IImmersiveLiveCardSystemVm } from '../../../common/interface/IImmersiveLiveCardSystemVm';
import { IImmersiveLiveItemVm } from '../../../common/interface/IImmersiveLiveItemVm';
import { IImmersiveLiveMenuVm } from '../../../common/interface/IImmersiveLiveMenuVm';
import { IImmersiveLiveNavigationVm } from '../../../common/interface/IImmersiveLiveNavigationVm';
import { IImmersiveLiveOtherExtendVm } from '../../../common/interface/IImmersiveLiveOtherExtendVm';
import { IImmersiveLiveOtherProgressVm } from '../../../common/interface/IImmersiveLiveOtherProgressVm';
import { IImmersiveLiveSysBtnVm } from '../../../common/interface/IImmersiveLiveSysBtnVm';
import { IImmersiveLiveSysProgressVm } from '../../../common/interface/IImmersiveLiveSysProgressVm';
import { IImmersiveLiveVmInjector } from '../../../common/interface/IImmersiveLiveVmInjector';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { IImmStyleConfigHelper } from '../../../common/interface/IImmStyleConfigHelper';
import { IImmersiveLiveOtherFlightVm } from '../../../common/interface/IImmersiveLiveOtherFlightVm';
import { ImmItemHelperVm } from '../helper/ImmItemHelperVm';
import { ImmersiveLiveAuthorizationVm } from '../vm/ImmersiveLiveAuthorizationVm';
import { ImmersiveLiveItemVm } from '../vm/ImmersiveLiveItemVm';
import { ImmersiveLiveMenuVm } from '../vm/ImmersiveLiveMenuVm';
import { ImmListLiveNavVm } from '../vm/ImmListLiveNavVm';
import { ImmersiveLiveOtherExtendVm } from '../vm/ImmersiveLiveOtherExtendVm';
import { ImmersiveLiveOtherFlightVm } from '../vm/ImmersiveLiveOtherFlightVm';
import { ImmersiveLiveOtherProgressVm } from '../vm/ImmersiveLiveOtherProgressVm';
import { ImmersiveLiveSysBtnVm } from '../vm/ImmersiveLiveSysBtnVm';
import { ImmersiveLiveSysProgressVm } from '../vm/ImmersiveLiveSysProgressVm';
import { ImmListLiveCardOtherVm } from '../vm/ImmListLiveCardOtherVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmComVm } from '../../../common/interface/IImmComVm';
import { ImmComVm } from '../vm/ImmComVm';
import { ImmListLiveCardSysVm } from '../vm/ImmListLiveCardSysVm';
import { ImmColorVm } from '../../../common/color/ImmColorVm';
import { ImmLiveActionBtnVm } from '../vm/ImmLiveActionBtnVm';
import { IImmLiveActionBtnVm } from '../../../common/interface/IImmLiveActionBtnVm';
import { IImmLiveOtherPickupVm } from '../../../common/interface/IImmLiveCardOtherPickupVm';
import { ImmLiveOtherPickupVm } from '../vm/ImmLiveOtherPickupVm';
import { IImmLiveOtherScoreVm } from '../../../common/interface/IImmLiveCardOtherScoreVm';
import { ImmLiveOtherScoreVm } from '../vm/ImmLiveOtherScoreVm';
import { ImmersiveLiveStarterVm } from '../vm/ImmersiveLiveStarterVm';

/**
 * 沉浸锁屏实况通知注入，列表、胶囊、大图通用场景
 */
export class ImmersiveLiveVmInjector extends LiveVmInjector implements IImmersiveLiveVmInjector {
  // 通用注入器
  private ntfVmInjector?: IImmersiveNtfVmInjector;

  // 锁屏状态管理器名称
  protected readonly stateMgrName: SlStateMgr;

  /**
   * 锁屏面板场景
   */
  public readonly scene: SystemUIUseScene = SystemUIUseScene.KG;
  protected enableDelayDeleteVm: boolean = false;

  /**
   * 构造
   *
   * @param mgrName 状态管理器名称
   */
  constructor(mgrName: SlStateMgr) {
    super();
    this.stateMgrName = mgrName;
  }

  /**
   * 注入通用注入器
   *
   * @param vmInjector 注入器
   */
  public setNtfVmInjector(vmInjector: IImmersiveNtfVmInjector): void {
    this.ntfVmInjector = vmInjector;
  }

  /**
   * 状态管理器名
   *
   * @returns 管理器名
   */
  getStateMgr(): SlStateMgr {
    return this.stateMgrName;
  }

  /**
   * 通用注入器
   *
   * @returns 注入器
   */
  getNtfVmInjector(): IImmersiveNtfVmInjector | undefined {
    return this.ntfVmInjector;
  }

  /**
   * 颜色控制器
   *
   * @returns 颜色控制器
   */
  public getColorVm(): ImmColorVm {
    return ImmColorVm.getInstance();
  }

  /**
   * 清空所有item对应的VM
   */
  deleteVmByAllLive(): void {
    this.foreachVm((vm, key) => {
      if (!(vm instanceof LiveItemBaseVm)) {
        return;
      }
      vm.destroy();
      this.deleteVm(key);
    });
  }

  /**
   * 沉浸实况侧滑菜单业务管理器
   *
   * @param live 实况数据
   * @returns 侧滑菜单业务管理器
   */
  getCardMenuVm(live: LiveNotification): IImmersiveLiveMenuVm {
    return this.getVm(this.getKey(ImmersiveLiveMenuVm, live), () => new ImmersiveLiveMenuVm(this, live));
  }

  /**
   * 沉浸实况三方卡片业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片业务管理器
   */
  getCardOtherVm(live: LiveNotification): IImmersiveLiveCardOtherVm {
    return this.getVm(this.getKey(ImmListLiveCardOtherVm, live), () => new ImmListLiveCardOtherVm(this, live));
  }

  /**
   * 沉浸实况系统卡片业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片业务管理器
   */
  getCardSystemVm(live: LiveNotification): IImmersiveLiveCardSystemVm {
    return this.getVm(this.getKey(ImmListLiveCardSysVm, live), () => new ImmListLiveCardSysVm(this, live));
  }

  /**
   * 沉浸实况条目业务管理器
   *
   * @param live 实况数据
   * @returns 条目业务管理器
   */
  getCardListItemVm(live: LiveNotification): IImmersiveLiveItemVm {
    return this.getVm(this.getKey(ImmersiveLiveItemVm, live), () => new ImmersiveLiveItemVm(this, live));
  }

  /**
   * 沉浸实况导航模板业务管理器
   *
   * @param live 实况数据
   * @returns 导航模板业务管理器
   */
  getCardNavigationVm(live: LiveNotification): IImmersiveLiveNavigationVm {
    return this.getVm(this.getKey(ImmListLiveNavVm, live), () => new ImmListLiveNavVm(this, live));
  }

  /**
   * 沉浸实况三方卡片扩展区业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片扩展区业务管理器
   */
  getCardOtherExtendVm(live: LiveNotification): IImmersiveLiveOtherExtendVm {
    return this.getVm(this.getKey(ImmersiveLiveOtherExtendVm, live), () => new ImmersiveLiveOtherExtendVm(this, live));
  }

  /**
   * 沉浸实况系统卡片按钮业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片按钮业务管理器
   */
  getCardSystemButtonVm(live: LiveNotification): IImmersiveLiveSysBtnVm {
    return this.getVm(this.getKey(ImmersiveLiveSysBtnVm, live), () => new ImmersiveLiveSysBtnVm(this, live));
  }

  /**
   * 沉浸实况卡片授权业务管理器
   *
   * @param live 实况数据
   * @returns 卡片授权业务管理器
   */
  getCardAuthorizationVm(live: LiveNotification): IImmersiveLiveAuthorizationVm {
    return this.getVm(this.getKey(ImmersiveLiveAuthorizationVm, live),
      () => new ImmersiveLiveAuthorizationVm(this, live));
  }

  /**
   * 实况按钮业务管理器
   *
   * @param live 实况数据
   * @returns 实况按钮业务
   */
  getLiveActionButtonVm(live: LiveNotification): IImmLiveActionBtnVm {
    return this.getVm(this.getKey(ImmLiveActionBtnVm, live), () => new ImmLiveActionBtnVm(this, live));
  }

  /**
   * 沉浸实况三方卡片进度条业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片业务管理器
   */
  getCardOtherProgressVm(live: LiveNotification): IImmersiveLiveOtherProgressVm {
    return this.getVm(this.getKey(ImmersiveLiveOtherProgressVm, live),
      () => new ImmersiveLiveOtherProgressVm(this, live));
  }

  /**
   * 沉浸实况系统卡片进度环业务管理器
   *
   * @param live 实况数据
   * @returns 系统卡片进度环业务管理器
   */
  getCardSystemProgressVm(live: LiveNotification): IImmersiveLiveSysProgressVm {
    return this.getVm(this.getKey(ImmersiveLiveSysProgressVm, live), () => new ImmersiveLiveSysProgressVm(this, live));
  }

  /**
   * 沉浸模块条目状态辅助工具统一管理业务
   *
   * @returns 辅助工具管理业务
   */
  getImmItemHelperVm(): IImmItemHelperVm {
    return ImmItemHelperVm.getInstance(this.stateMgrName);
  }

  /**
   * 沉浸模块默认样式配置辅助工具
   *
   * @returns 样式配置工具
   */
  getImmStyleConfigHelper(): IImmStyleConfigHelper {
    return ImmStyleConfigH.getInstance(this.stateMgrName);
  }

  /**
   * 沉浸模块通用能力
   *
   * @returns 通用能力
   */
  getImmComVm(): IImmComVm | undefined {
    if (this.ntfVmInjector) {
      return ImmComVm.getInstance(this.ntfVmInjector);
    }
    return undefined;
  }

  /**
   * 沉浸实况三方卡片左右卡片拓展区业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片左右卡片拓展区业务管理器
   */
  getCardOtherFlightVm(live: LiveNotification): IImmersiveLiveOtherFlightVm {
    return this.getVm(this.getKey(ImmersiveLiveOtherFlightVm, live), () => new ImmersiveLiveOtherFlightVm(this, live));
  }

  /**
   * 沉浸实况三方卡片取餐卡片拓展区业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片取餐卡片拓展区业务管理器
   */
  getCardOtherPickupVm(live: LiveNotification): IImmLiveOtherPickupVm {
    return this.getVm(this.getKey(ImmLiveOtherPickupVm, live), () => new ImmLiveOtherPickupVm(this, live));
  }

  /**
   * 沉浸实况三方卡片比分卡片拓展区业务管理器
   *
   * @param live 实况数据
   * @returns 三方卡片比分卡片拓展区业务管理器
   */
  getCardOtherScoreVm(live: LiveNotification): IImmLiveOtherScoreVm {
    return this.getVm(this.getKey(ImmLiveOtherScoreVm, live), () => new ImmLiveOtherScoreVm(this, live));
  }

  /**
   * 沉浸实况启动业务管理
   *
   * @returns 启动业务管理
   */
  getStarterVm(): ILiveStarterVm {
    return this.getVm(ImmersiveLiveStarterVm.name, () => new ImmersiveLiveStarterVm(this));
  }
}