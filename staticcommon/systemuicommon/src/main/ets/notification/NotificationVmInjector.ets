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

import { BaseVmInjector } from '../vm/BaseVmInjector';
import { NotificationItemBaseVm } from './vm/NotificationBaseVm';
import { INotificationCardFloatingVm } from './interface/INotificationCardFloatingVm';
import { NotificationBase } from '../model/NotificationBase';
import { INotificationClearButtonVm } from './interface/INotificationClearButtonVm';
import { INotificationCardVm } from './interface/INotificationCardVm';
import { INotificationListVm } from './interface/INotificationListVm';
import { INotificationListScrollerVm } from './interface/INotificationListScrollerVm';
import { INotificationPanelVm } from './interface/INotificationPanelVm';
import { INotificationMoreVm } from './interface/INotificationMoreVm';
import { INotificationNormalGroupVm } from './interface/INotificationNormalGroupVm';
import { INotificationNormalVm } from './interface/INotificationNormalVm';
import { INotificationHeaderVm } from './interface/INotificationHeaderVm';
import { INotificationSwipeVm } from './interface/INotificationSwipeVm';
import { INotificationMenuVm } from './interface/INotificationMenuVm';
import { INotificationSettingDialogVm } from './interface/INotificationSettingDialogVm';
import { INotificationStarterVm } from './interface/INotificationStarterVm';
import { INotificationPinTopLimitDialogVm } from './interface/INotificationPinTopLimitDialogVm';
import { INotificationTimeVm } from './interface/INotificationTimeVm';
import { INotificationMoreHeaderVm } from './interface/INotificationMoreHeaderVm';
import { NormalNotification } from '../model/NormalNotification';
import { INotificationActionButtonVm } from './interface/INotificationActionButtonVm';
import { INotificationBannerVm } from './interface/INotificationBannerVm';
import { INotificationImmersiveVm } from './interface/INotificationImmersiveVm';
import { INotificationVerticalSwipeVm } from './interface/INotificationVerticalSwipeVm';
import { INotificationPrivacyVm } from './interface/INotificationPrivacyVm';
import { INotificationVmInjector } from './interface/INotificationVmInjector';
import { ViewName } from '../utils/ArkUIAdapter'
import { INotificationSilenceVm } from './interface/INotificationSilenceVm';
import { NotificationDataManager } from '../manager/NotificationDataManager';
import { NormalNotificationGroup } from '../model/NormalNotificationGroup';
import { INotificationDataPlanVm } from './interface/INotificationDataPlanVm';

export abstract class NotificationVmInjector extends BaseVmInjector implements INotificationVmInjector {
  public viewName: ViewName = ViewName.UNKNOWN;

  /**
   * 空的占位符，用于赋值给装饰@Consumer的变量，解决@Consumer必须指定初始值的问题
   */
  public static HOLDER = 0 as Object as NotificationVmInjector;

  protected enableDelayDeleteVm: boolean = true;

  /**
   * 获取通知面板VM
   * @returns
   */
  getPanelVm(): INotificationPanelVm {
    throw new Error('Not implement for required method [getPanelVm]');
  }

  /**
   * 获取通知列表VM
   * @returns
   */
  getListVm(): INotificationListVm | undefined {
    return undefined;
  }

  /**
   * 获取通知列表滚动条VM
   * @returns
   */
  getListScrollerVm(): INotificationListScrollerVm | undefined {
    return undefined;
  }

  /**
   * 获取一键清除按钮VM
   * @returns
   */
  getClearButtonVm(): INotificationClearButtonVm | undefined {
    return undefined;
  }

  /**
   * 获取通知卡片VM
   * @param ntf 通知数据
   * @returns
   */
  getCardVm(ntf: NotificationBase): INotificationCardVm {
    throw new Error('Not implement for required method [getCardVm]');
  }

  getCardFloatingVm(ntf: NotificationBase): INotificationCardFloatingVm {
    throw new Error('Not implement for required method [getCardFloatingVm]');
  }

  /**
   * 获取通用组通知卡片VM
   * @param ntf 通知数据
   * @returns
   */
  getNormalGroupVm(ntf: NotificationBase): INotificationNormalGroupVm | undefined {
    return undefined;
  }

  /**
   * 获取普通通知VM
   * @param ntf 通知数据
   * @returns
   */
  getNormalVm(ntf: NormalNotification): INotificationNormalVm {
    throw new Error('Not implement for required method [getNormalVm]');
  }

  /**
   * 获取通知隐私VM
   * @param ntf
   * @returns
   */
  getPrivacyVm(ntf: NotificationBase): INotificationPrivacyVm {
    throw new Error('Not implement for required method [getPrivacyVm]');
  }

  /**
   * 获取单通知卡片按钮VM
   * @param ntf 通知数据
   * @returns
   */
  getActionButtonVm(ntf: NormalNotification): INotificationActionButtonVm {
    throw new Error('Not implement for required method [getActionButtonVm]');
  }

  /**
   * 获取更多通知卡片VM
   * @param ntf 通知数据
   * @returns
   */
  getMoreVm(): INotificationMoreVm | undefined {
    return undefined;
  }

  /**
   * 获取通知面板头部VM
   * @returns
   */
  getHeaderVm(): INotificationHeaderVm | undefined {
    return undefined;
  }

  /**
   * 获取通知横滑VM
   * @param ntf 通知数据
   * @returns
   */
  getSwipeVm(ntf: NotificationBase): INotificationSwipeVm | undefined {
    return undefined;
  }

  /**
   * 获取通知菜单VM
   * @param ntf 通知
   * @returns
   */
  getMenuVm(ntf: NotificationBase): INotificationMenuVm | undefined {
    return undefined;
  }

  /**
   * 获取通知卡片启动的VM
   * @param ntf 通知
   * @returns
   */
  getStarterVm(): INotificationStarterVm {
    throw new Error('Not implement for required method [getStarterVm]');
  }

  /**
   * 获取可扩展小外屏通知卡片启动的VM
   */
  getStarterOuterHomeVm(): INotificationStarterVm {
    throw new Error('Not implement for required method [getStarterOuterHomeVm]');
  }

  /**
   * 获取时间VM
   * @returns
   */
  getTimeVm(ntf: NotificationBase): INotificationTimeVm {
    throw new Error('Not implement for required method [getTimeVm]');
  }

  /**
   * 获取通知设置弹窗VM
   * @returns
   */
  getSettingDiagVm(): INotificationSettingDialogVm | undefined {
    return undefined;
  }

  /**
   * 获取通知置顶超限制弹窗VM
   * @returns
   */
  getPinTopDialogVm(): INotificationPinTopLimitDialogVm {
    throw new Error('Not implement for required method [getPinTopDialogVm]');
  }

  /**
   * 获取通知静默VM
   * @returns
   */
  getSilenceVm(): INotificationSilenceVm {
    throw new Error('Not implement for required method [getSilenceVm]');
  }

  /**
   * 获取横幅通知VM
   * @returns
   */
  getBannerVm(): INotificationBannerVm {
    throw new Error('Not implement for required method [getBannerVm]');
  }

  /**
   * 获取横幅沉浸态通知VM
   * @returns
   */
  getImmersiveVm(): INotificationImmersiveVm {
    throw new Error('Not implement for required method [getImmersiveVm]');
  }

  /**
   * 获取横幅下拉VM
   * @returns
   */
  getVerticalSwipeVm(): INotificationVerticalSwipeVm | undefined {
    return undefined;
  }

  /**
   * 获取流量套餐信息VM
   * @returns
   */
  getDataPlanVm(): INotificationDataPlanVm | undefined {
    throw new Error('Not implement for required method [getDataPlanVm]');
  }

  /**
   * 获取VM实例
   * @param key VM实例的唯一标识
   * @param getInstance
   * @returns
   */
  protected getVm<T>(key: string, getInstance: () => T): T {
    if (!this.vmMap.has(key)) {
      const instance = getInstance() as Object;
      if (instance instanceof NotificationItemBaseVm) {
        instance.init();
      }
      this.vmMap.set(key, instance);
    }
    return this.vmMap.get(key) as T;
  }

  /**
   * 获取更多通知头部VM
   * @returns
   */
  getNotificationMoreHeaderVm(): INotificationMoreHeaderVm | undefined {
    return undefined;
  }

  /**
   * 获取通知VM的key
   * @param vmClass
   * @param ntf
   * @returns
   */
  protected getKey(vmClass: Function, ntf: NotificationBase): string {
    return `[${ntf?.key}]${vmClass.name}`;
  }

  protected onCreateVm(vm: Object): void {
    if (vm instanceof NotificationItemBaseVm) {
      vm.init();
    }
  }

  /**
   * 清理某个通知对应的所有VM
   * @param ntf
   */
  public deleteVmByNtf(ntf: NotificationBase): void {
    this.foreachVm((vm, key) => {
      if (!(vm instanceof NotificationItemBaseVm)) {
        return;
      }
      const existNtf = vm.ntf as NotificationBase;
      if (existNtf?.key !== ntf.key) {
        return;
      }
      vm.destroy();
      this.deleteVm(key);
    });
  }

  /**
   * 更新某个通知对应的所有VM的数据
   * @param ntf
   */
  public updateVmByNtf(ntf: NotificationBase): void {
    this.foreachVm((vm, key) => {
      if (!(vm instanceof NotificationItemBaseVm)) {
        return;
      }
      const existNtf = vm.ntf as NotificationBase;
      if (existNtf?.key !== ntf.key) {
        return;
      }
      vm.onUpdate(ntf);
    });
  }

  /**
   * 清理所有单通知对应的VM
   */
  public deleteVmByAllNtf(): void {
    this.foreachVm((vm, key) => {
      if (!(vm instanceof NotificationItemBaseVm)) {
        return;
      }
      vm.destroy();
      this.deleteVm(key);
    });
  }

  protected isVmPossibleLeak(vm: Object): boolean {
    if (!(vm instanceof NotificationItemBaseVm)) {
      return false;
    }
    if (vm.ntf instanceof NormalNotificationGroup) {
      return this.getListVm()?.getNtfByGroupKey(vm.ntf.groupKey)?.key !== vm.ntf.key;
    }
    return NotificationDataManager.instance.ntfMap.get(vm.ntf.hashCode)?.key !== vm.ntf.key;
  }
}