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
import { NotificationVmInjector } from '@ohos/systemuicommon/newIndex';
import { SystemUIUseScene, NotificationBase, NormalNotification } from '@ohos/systemuicommon/newTsIndex';
import { ISlClockAnimVm } from '../../../common/interface/ISlClockAnimVm';
import { IImmersiveCapVm } from '../../../common/interface/IImmersiveCapVm';
import { IImmersiveListVm } from '../../../common/interface/IImmersiveListVm';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { IImmersiveMeshVm } from '../../../common/interface/IImmersiveMeshVm';
import { IImmersivePanelVm } from '../../../common/interface/IImmersivePanelVm';
import { IImmersiveNtfTimeVm } from '../../../common/interface/IImmersiveNtfTimeVm';
import { IImmersiveNtfMenuVm } from '../../../common/interface/IImmersiveNtfMenuVm';
import { IImmersiveNtfItemVm } from '../../../common/interface/IImmersiveNtfItemVm';
import { IImmersiveCapAnimVm } from '../../../common/interface/IImmersiveCapAnimVm';
import { IImmersiveNtfSwipeVm } from '../../../common/interface/IImmersiveNtfSwipeVm';
import { IImmersiveListHandle } from '../../../common/interface/IImmersiveListHandle';
import { IImmersiveListAnimVm } from '../../../common/interface/IImmersiveListAnimVm';
import { IImmersiveCardAnimVm } from '../../../common/interface/IImmersiveCardAnimVm';
import { IImmStyleConfigHelper } from '../../../common/interface/IImmStyleConfigHelper';
import { IImmersiveNtfNormalVm } from '../../../common/interface/IImmersiveNtfNormalVm';
import { IImmersiveWholeAnimVm } from '../../../common/interface/IImmersiveWholeAnimVm';
import { IImmersiveNtfPinTopVm } from '../../../common/interface/IImmersiveNtfPinTopVm';
import { IImmersiveNtfStarterVm } from '../../../common/interface/IImmersiveNtfStarterVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmersiveNtfActionBtnVm } from '../../../common/interface/IImmersiveNtfActionBtnVm';
import { IImmersiveNtfNormalGroupVm } from '../../../common/interface/IImmersiveNtfNormalGroupVm';
import { IImmLifeCycleVm, IImmLifeCycleVmArray } from '../../../common/interface/IImmLifeCycleVm';
import { IImmDataShareVm, IImmDataShareVmArray } from '../../../common/interface/IImmDataShareVm';
import { IImmersiveNtfSettingDialogVm } from '../../../common/interface/IImmersiveNtfSettingDialogVm';
import { IGraftNtfListVm } from '../../../common/interface/IGraftNtfListVm';
import { IImmersiveDataVm } from '../../../common/interface/IImmersiveDataVm';
import { IImmersiveCardVm } from '../../../common/interface/IImmersiveCardVm';
import { IImmersiveLiveVmInjector,
  IImmersiveLiveVmInjectorArr } from '../../../common/interface/IImmersiveLiveVmInjector';
import { ImmItemHelperVm } from '../helper/ImmItemHelperVm';
import { ImmStyleConfigH } from '../../../model/helper/ImmStyleConfigHelper';
import { ImmersivePanelVm } from '../vm/ImmersivePanelVm';
import { ImmersiveNtfCapVm } from '../vm/ImmersiveNtfCapVm';
import { ImmersiveNtfTimeVm } from '../vm/ImmersiveNtfTimeVm';
import { ImmersiveNtfMenuVm } from '../vm/ImmersiveNtfMenuVm';
import { ImmersiveNtfListVm } from '../vm/ImmersiveNtfListVm';
import { ImmersiveNtfSwipeVm } from '../vm/ImmersiveNtfSwipeVm';
import { ImmersiveNtfNormalVm } from '../vm/ImmersiveNtfNormalVm';
import { ImmersiveNtfPinTopVm } from '../vm/ImmersiveNtfPinTopVm';
import { ImmersiveNtfStarterVm } from '../vm/ImmersiveNtfStarterVm';
import { ImmersiveNtfListItemVm } from '../vm/ImmersiveNtfListItemVm';
import { ImmersiveNtfActionBtnVm } from '../vm/ImmersiveNtfActionBtnVm';
import { ImmersiveNtfNormalGroupVm } from '../vm/ImmersiveNtfNormalGroupVm';
import { ImmersiveNtfSettingDialogVm } from '../vm/ImmersiveNtfSettingDialogVm';
import { ImmersiveNtfCardVm } from '../vm/ImmersiveNtfCardVm';
import { ImmersiveDataVm } from '../vm/ImmersiveDataVm';
import { GraftNtfListVm } from '../vm/GraftNtfListVm';
import { ImmComVm } from '../vm/ImmComVm';
import { ImmWholeAnimMgrV2 } from '../anim/ImmWholeAnimManagerV2';
import { ImmListAnimMgrV2 } from '../anim/ImmListAnimManagerV2';
import { ImmCapAnimMgrV2 } from '../anim/ImmCapAnimMgrV2';
import { ImmCardAnimMgrV2 } from '../anim/ImmCardAnimMgrV2';
import { SlClockAnimManager } from '../../viewanim/SlClockAnimManager';
import { ImmersiveListHandle } from '../../viewevent/ImmersiveListHandle';
import { ImmersiveMeshManager } from '../../viewlayout/ImmersiveMeshManager';
import { ImmersiveNtfPrivacyVm } from '../vm/ImmersiveNtfPrivacyVm';
import { IImmersiveNtfPrivacyVm } from '../../../common/interface/IImmersiveNtfPrivacyVm';
import { IImmComVm } from '../../../common/interface/IImmComVm';
import { IImmV1StateVm } from '../../../common/interface/IImmV1StateVm';
import { IImmersiveLiveTimerVm } from '../../../common/interface/IImmersiveLiveTimerVm';
import { IImmLiveDataVm } from '../../../common/interface/IImmLiveDataVm';
import { ImmV1StateVm } from '../vm/ImmV1StateVm';
import { ICapAnimChainVm } from '../../../common/interface/ICapAnimChainVm';
import { CapAnimChainHelper } from '../../../model/helper/CapAnimChainHelper';
import { IImmersiveCapsuleHandle } from '../../../common/interface/IImmersiveCapsuleHandle';
import { ImmersiveCapsuleHandle } from '../../viewevent/ImmersiveCapsuleHandle';
import { IImmersiveCardHandle } from '../../../common/interface/IImmersiveCardHandle';
import { ImmersiveCardHandle } from '../../viewevent/ImmersiveCardHandle';
import { IImmCapRemindVm } from '../../../common/interface/IImmCapRemindVm';
import { ImmCapRemindVm } from '../vm/ImmCapRemindVm';
import { IImmGestureEventVm, IImmGestureEventVmArray } from '../../../common/interface/IImmGestureEventVm';
import { ICardAnimChainVm } from '../../../common/interface/ICardAnimChainVm';
import { IImmSilenceVm } from '../../../common/interface/IImmSilenceVm';
import { ImmSilenceVm } from '../vm/ImmSilenceVm';
import { ImmLiveDataVm } from '../vm/ImmLiveDataVm';
import { CardAnimChainHelper } from '../../../model/helper/CardAnimChainHelper';
import { IImmersiveFloatingVm } from '../../../common/interface/IImmersiveFloatingVm';
import { ImmersiveFloatingVm } from '../vm/ImmersiveFloatingVm';
import { ImmColorVm } from '../../../common/color/ImmColorVm';
import { ICapLifeCycleAnimFactory } from '../../../common/interface/ICapLifeCycleAnimFactory';
import { ICardLifeCycleAnimFactory } from '../../../common/interface/ICardLifeCycleAnimFactory';
import { IImmHybridAnimFactory } from '../../../common/interface/IImmHybridAnimFactory';
import { CapLifeCycleAnimFactory } from '../anim/factory/CapLifeCycleAnimFactory';
import { CardLifeCycleAnimFactory } from '../anim/factory/CardLifeCycleAnimFactory';
import { ImmHybridAnimFactory } from '../anim/factory/ImmHybridAnimFactory';

/**
 * 沉浸锁屏通知通用业务注入，列表、胶囊通用场景
 */
export class ImmersiveNtfVmInjector extends NotificationVmInjector implements IImmersiveNtfVmInjector {
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
   * 状态管理器名
   *
   * @returns 管理器名
   */
  getStateMgr(): SlStateMgr {
    return this.stateMgrName;
  }

  /**
   * 沉浸列表面板业务管理器
   *
   * @returns 面板业务管理器
   */
  getPanelVm(): IImmersivePanelVm {
    return this.getVm(ImmersivePanelVm.name, () => new ImmersivePanelVm(this));
  }

  /**
   * 颜色控制器
   *
   * @returns 颜色控制器
   */
  getColorVm(): ImmColorVm {
    return ImmColorVm.getInstance();
  }

  /**
   * 沉浸模块数据处理业务
   *
   * @returns 数据处理业务
   */
  getImmDataVm(): IImmersiveDataVm {
    return this.getVm(ImmersiveDataVm.name, () => new ImmersiveDataVm(this));
  }

  /**
   * 沉浸列表整体业务管理器
   *
   * @returns 沉浸列表业务管理器
   */
  getImmersiveListVm(): IImmersiveListVm {
    return this.getVm(ImmersiveNtfListVm.name, () => new ImmersiveNtfListVm(this));
  }

  /**
   * 嫁接通知中心List业务管理器
   *
   * @returns 嫁接List业务管理器
   */
  getListVm(): IGraftNtfListVm {
    return this.getVm(GraftNtfListVm.name, () => new GraftNtfListVm(this));
  }

  /**
   * 沉浸列表条目业务管理器
   *
   * @param ntf 条目数据
   * @returns 条目业务管理器
   */
  getCardVm(ntf: NotificationBase): IImmersiveNtfItemVm {
    return this.getVm(this.getKey(ImmersiveNtfListItemVm, ntf), () => new ImmersiveNtfListItemVm(this, ntf));
  }

  /**
   * 沉浸列表普通通知条目业务管理器
   *
   * @param ntf 条目数据
   * @returns 普通通知业务管理器
   */
  getNormalVm(ntf: NormalNotification): IImmersiveNtfNormalVm {
    return this.getVm(this.getKey(ImmersiveNtfNormalVm, ntf), () => new ImmersiveNtfNormalVm(this, ntf));
  }

  /**
   * 沉浸列表隐藏通知内容管理器
   *
   * @param ntf 条目数据
   * @returns 隐藏通知内容管理器
   */
  getPrivacyVm(ntf: NotificationBase): IImmersiveNtfPrivacyVm {
    return this.getVm(this.getKey(ImmersiveNtfPrivacyVm, ntf), () => new ImmersiveNtfPrivacyVm(this, ntf));
  }

  /**
   * 沉浸列表组通知条目业务管理器
   *
   * @param ntf 条目数据
   * @returns 组通知业务管理器
   */
  getNormalGroupVm(ntf: NotificationBase): IImmersiveNtfNormalGroupVm {
    return this.getVm(this.getKey(ImmersiveNtfNormalGroupVm, ntf), () => new ImmersiveNtfNormalGroupVm(this, ntf));
  }

  /**
   * 沉浸列表条目action按钮业务管理器
   *
   * @param ntf 条目数据
   * @returns action按钮业务管理器
   */
  getActionButtonVm(ntf: NormalNotification): IImmersiveNtfActionBtnVm {
    return this.getVm(this.getKey(ImmersiveNtfActionBtnVm, ntf), () => new ImmersiveNtfActionBtnVm(this, ntf));
  }

  /**
   * 沉浸列表条目侧滑业务管理器
   *
   * @param ntf 条目数据
   * @returns 侧滑业务管理器
   */
  getSwipeVm(ntf: NotificationBase): IImmersiveNtfSwipeVm {
    return this.getVm(this.getKey(ImmersiveNtfSwipeVm, ntf), () => new ImmersiveNtfSwipeVm(this, ntf));
  }

  /**
   * 沉浸列表条目菜单按钮业务管理器
   *
   * @param ntf 条目数据
   * @returns 菜单按钮业务管理器
   */
  getMenuVm(ntf: NotificationBase): IImmersiveNtfMenuVm {
    return this.getVm(this.getKey(ImmersiveNtfMenuVm, ntf), () => new ImmersiveNtfMenuVm(this, ntf));
  }

  /**
   * 沉浸列表条目点击启动业务管理器
   *
   * @returns 条目点击启动业务管理器
   */
  getStarterVm(): IImmersiveNtfStarterVm {
    return this.getVm(ImmersiveNtfStarterVm.name, () => new ImmersiveNtfStarterVm(this));
  }

  /**
   * 沉浸列表条目时间显示业务管理器
   *
   * @param ntf 条目数据
   * @returns 时间显示业务管理器
   */
  getTimeVm(ntf: NotificationBase): IImmersiveNtfTimeVm {
    return this.getVm(this.getKey(ImmersiveNtfTimeVm, ntf), () => new ImmersiveNtfTimeVm(this, ntf));
  }

  /**
   * 沉浸列表条目设置弹框业务管理器
   *
   * @returns 设置弹框业务管理器
   */
  getSettingDiagVm(): IImmersiveNtfSettingDialogVm {
    return this.getVm(ImmersiveNtfSettingDialogVm.name, () => new ImmersiveNtfSettingDialogVm(this));
  }

  /**
   * 沉浸列表条目置顶弹框业务管理器
   *
   * @returns 置顶弹框业务管理器
   */
  getPinTopDialogVm(): IImmersiveNtfPinTopVm {
    return this.getVm(ImmersiveNtfPinTopVm.name, () => new ImmersiveNtfPinTopVm(this));
  }

  getSilenceVm(): IImmSilenceVm {
    // 静默通知业务
    return this.getVm(ImmSilenceVm.name, () => new ImmSilenceVm(this));
  }

  /**
   * 沉浸栅格业务管理器
   *
   * @returns 栅格业务管理器
   */
  getImmersiveMeshVm(): IImmersiveMeshVm {
    return this.getVm(ImmersiveMeshManager.name, () => {
      let mesh = ImmersiveMeshManager.getInstance();
      mesh.setVmInjector(this);
      return mesh;
    });
  }

  /**
   * 沉浸列表事件处理业务管理器
   *
   * @returns 事件业务管理器
   */
  getImmersiveListHandle(): IImmersiveListHandle {
    return this.getVm(ImmersiveListHandle.name, () => {
      let listHandle = new ImmersiveListHandle();
      listHandle.setVmInjector(this);
      return listHandle;
    });
  }

  /**
   * 沉浸胶囊事件处理业务管理器
   *
   * @returns 事件业务管理器
   */
  getImmersiveCapsuleHandle(): IImmersiveCapsuleHandle {
    return this.getVm(ImmersiveCapsuleHandle.name, () => {
      let capsuleHandle = new ImmersiveCapsuleHandle();
      capsuleHandle.setVmInjector(this);
      return capsuleHandle;
    });
  }

  /**
   * 沉浸卡片事件处理业务管理器
   *
   * @returns 事件业务管理器
   */
  getImmersiveCardHandle(): IImmersiveCardHandle {
    return this.getVm(ImmersiveCardHandle.name, () => {
      let cardHandle = new ImmersiveCardHandle();
      cardHandle.setVmInjector(this);
      return cardHandle;
    });
  }

  /**
   * 沉浸模块全局动效业务管理器
   *
   * @returns 全局动效业务管理器
   */
  getImmersiveWholeAnimVm(): IImmersiveWholeAnimVm {
    return this.getVm(ImmWholeAnimMgrV2.name, () => {
      let mgr = new ImmWholeAnimMgrV2();
      mgr.setVmInjector(this);
      return mgr;
    });
  }

  /**
   * 沉浸模块列表动效业务管理器
   *
   * @returns 列表动效业务管理器
   */
  getImmersiveListAnimVm(): IImmersiveListAnimVm {
    return this.getVm(ImmListAnimMgrV2.name, () => new ImmListAnimMgrV2(this));
  }

  /**
   * 沉浸模块大卡动效业务管理器
   *
   * @returns 大卡动效业务管理器
   */
  getImmersiveCardAnimVm(): IImmersiveCardAnimVm {
    return this.getVm(ImmCardAnimMgrV2.name, () => new ImmCardAnimMgrV2(this));
  }

  /**
   * 沉浸模块胶囊动效业务管理器
   *
   * @returns 胶囊动效业务管理器
   */
  getImmersiveCapAnimVm(): IImmersiveCapAnimVm {
    return this.getVm(ImmCapAnimMgrV2.name, () => new ImmCapAnimMgrV2(this));
  }

  /**
   * 沉浸胶囊模块强提醒业务
   *
   * @returns 胶囊强提醒
   */
  getImmCapRemindVm(): IImmCapRemindVm {
    return this.getVm(ImmCapRemindVm.name, () => new ImmCapRemindVm(this));
  }

  /**
   * 锁屏时钟联合动效业务管理器
   *
   * @returns 时钟动效业务管理器
   */
  getSlClockAnimVm(): ISlClockAnimVm {
    return this.getVm(SlClockAnimManager.name, () => {
      let mgr = new SlClockAnimManager();
      mgr.setVmInjector(this);
      return mgr;
    });
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
   * 沉浸胶囊列表业务管理器
   *
   * @returns 胶囊业务管理器
   */
  getImmersiveCapVm(): IImmersiveCapVm {
    return this.getVm(ImmersiveNtfCapVm.name, () => new ImmersiveNtfCapVm(this));
  }

  /**
   * 沉浸大卡列表业务管理器
   *
   * @returns 大卡业务管理器
   */
  getImmersiveCardVm(): IImmersiveCardVm {
    return this.getVm(ImmersiveNtfCardVm.name, () => new ImmersiveNtfCardVm(this));
  }

  /**
   * 沉浸模块通知数据处理业务集
   *
   * @returns 数据处理业务集
   */
  getImmDataShareVmList(): IImmDataShareVm[] {
    return this.getVm(IImmDataShareVmArray.name, () => {
      let vmArr = new IImmDataShareVmArray();
      let config = this.getImmStyleConfigHelper()?.getImmConfig();
      if (config?.isListEnable()) {
        // 实况数据管理器
        this.pushArr(vmArr, this.getImmLiveDataVm());
        this.pushArr(vmArr, this.getImmersiveListVm());
      }
      if (config?.isCapEnable()) {
        this.pushArr(vmArr, this.getImmersiveCapVm());
      }
      if (config?.isCardEnable()) {
        this.pushArr(vmArr, this.getImmersiveCardVm());
      }
      return vmArr;
    });
  }

  /**
   * 沉浸模块生命周期业务集
   *
   * @returns 生命周期业务集
   */
  getImmLifeCycleVmList(): IImmLifeCycleVm[] {
    return this.getVm(IImmLifeCycleVmArray.name, () => {
      let vmArr = new IImmLifeCycleVmArray();
      // 沉浸模块整体业务
      vmArr.push(ImmComVm.getInstance(this));
      let config = this.getImmStyleConfigHelper()?.getImmConfig();
      if (config?.isListEnable()) {
        // 实况数据管理器
        this.pushArr(vmArr, this.getImmLiveDataVm());
        this.pushArr(vmArr, this.getImmersiveListVm());
        this.pushArr(vmArr, this.getImmersiveMeshVm());
      }
      if (config?.isCapEnable()) {
        // 动效检测器加入初始化
        this.pushArr(vmArr, this.getImmCapAnimChainVm());
        this.pushArr(vmArr, this.getImmersiveCapVm());
      }
      if (config?.isCardEnable()) {
        // 动效检测器加入初始化
        this.pushArr(vmArr, this.getImmCardAnimChainVm());
        this.pushArr(vmArr, this.getImmersiveCardVm());
      }
      return vmArr;
    });
  }

  /**
   * 沉浸模块手势业务集
   *
   * @returns 手势业务集
   */
  getImmGestureVmList(): IImmGestureEventVm[] {
    return this.getVm(IImmGestureEventVmArray.name, () => {
      let vmArr = new IImmGestureEventVmArray();
      let config = this.getImmStyleConfigHelper()?.getImmConfig();
      if (config?.isListEnable()) {
        this.pushArr(vmArr, this.getSettingDiagVm());
        this.pushArr(vmArr, this.getImmersiveListVm());
      }
      if (config?.isCapEnable()) {
        this.pushArr(vmArr, this.getImmersiveCapVm());
      }
      if (config?.isCardEnable()) {
        this.pushArr(vmArr, this.getImmersiveCardVm());
      }
      return vmArr;
    });
  }

  /**
   * 沉浸模块实况业务注入器集
   *
   * @returns 实况业务注入器集
   */
  getImmLiveVmInjectorList(): IImmersiveLiveVmInjector[] {
    return this.getVm(IImmersiveLiveVmInjectorArr.name, () => new IImmersiveLiveVmInjectorArr());
  }

  /**
   * 实况计时器
   *
   * @returns 实况计时器
   */
  getLiveTimerVm(): IImmersiveLiveTimerVm | undefined {
    return this.getImmLiveVmInjectorList()?.[0]?.getTimerVm();
  }

  /**
   * 沉浸模块实况数据管理器
   *
   * @returns 实况数据管理器
   */
  getImmLiveDataVm(): IImmLiveDataVm {
    return this.getVm(ImmLiveDataVm.name, () => new ImmLiveDataVm(this));
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
  getImmComVm(): IImmComVm {
    return ImmComVm.getInstance(this);
  }

  /**
   * V1状态管理
   *
   * @returns V1状态
   */
  getImmV1StateVm(): IImmV1StateVm {
    return ImmV1StateVm.getInstance();
  }

  /**
   * 沉浸胶囊生命周期动效检测器
   *
   * @returns 动效检测器
   */
  getImmCapAnimChainVm(): ICapAnimChainVm {
    return this.getVm(CapAnimChainHelper.name, () => new CapAnimChainHelper(this));
  }

  /**
   * 沉浸大卡生命周期动效检测器
   *
   * @returns 动效检测器
   */
  getImmCardAnimChainVm(): ICardAnimChainVm {
    return this.getVm(CardAnimChainHelper.name, () => new CardAnimChainHelper(this));
  }

  /**
   * 沉浸胶囊生命周期动效工厂
   *
   * @returns 动效工厂
   */
  getCapLifeCycleAnimFactory(): ICapLifeCycleAnimFactory {
    return this.getVm(CapLifeCycleAnimFactory.name, () => new CapLifeCycleAnimFactory(this));
  }

  /**
   * 沉浸大卡生命周期动效工厂
   *
   * @returns 动效工厂
   */
  getCardLifeCycleAnimFactory(): ICardLifeCycleAnimFactory {
    return this.getVm(CardLifeCycleAnimFactory.name, () => new CardLifeCycleAnimFactory(this));
  }

  /**
   * 沉浸锁屏模块联合动效工厂
   *
   * @returns 动效工厂
   */
  getImmHybridAnimFactory(): IImmHybridAnimFactory {
    return this.getVm(ImmHybridAnimFactory.name, () => new ImmHybridAnimFactory(this));
  }

  /**
   * 沉浸锁屏模块悬浮窗业务
   *
   * @param ntf 通知数据
   * @returns 悬浮窗业务
   */
  getCardFloatingVm(ntf: NotificationBase): IImmersiveFloatingVm {
    return this.getVm(this.getKey(ImmersiveFloatingVm, ntf), () => new ImmersiveFloatingVm(this, ntf));
  }

  /**
   * 更新条目VM
   *
   * @param ntf 条目数据
   */
  public updateVmByNtf(ntf: NotificationBase): void {
    super.updateVmByNtf(ntf);
    // 实况数据，则同步刷新
    if (ntf?.isLiveView()) {
      this.getImmLiveVmInjectorList()?.forEach((injector) => injector?.updateVmByLive(ntf));
    }
  }

  /**
   * 清除条目VM
   *
   * @param ntf 条目数据
   */
  public deleteVmByNtf(ntf: NotificationBase): void {
    super.deleteVmByNtf(ntf);
    // 实况数据，则同步清除
    if (ntf?.isLiveView()) {
      this.getImmLiveVmInjectorList()?.forEach((injector) => injector?.deleteVmByLive(ntf));
    }
  }

  /**
   * 清除全部单条目VM
   */
  public deleteVmByAllNtf(): void {
    super.deleteVmByAllNtf();
    // 实况同步清除
    this.getImmLiveVmInjectorList()?.forEach((injector) => injector?.deleteVmByAllLive());
  }

  /**
   * 列表添加数据
   *
   * @param arr 列表
   * @param item 数据
   */
  private pushArr<T>(arr: Array<T>, item?: T) : void {
    if (item) {
      arr?.push(item);
    }
  }
}