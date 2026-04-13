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

import { LogDomain, Logger } from '@ohos/basicutils';
import { SCBOobeManager } from '@ohos/windowscene';
import { LimitMap } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { LimitSet } from '@ohos/screenlockcommon/Index';
import { immersiveKgMgr } from '@ohos/systemuicommon';
import { NotificationRefreshRecord } from '@ohos/systemuicommon/newIndex';
import { NotificationArray, NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { NotificationDataVm } from '@ohos/notificationcomponent/newIndex';
import { ImmersiveComHelper } from '../../../common/helper/ImmersiveComHelper';
import { IImmDataShare, ImmDataShareWrap } from '../../../common/interface/IImmDataShare';
import { IImmDataShareVmArray } from '../../../common/interface/IImmDataShareVm';
import { IImmersiveDataVm } from '../../../common/interface/IImmersiveDataVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmLifeCycleVmArray } from '../../../common/interface/IImmLifeCycleVm';
import { slImmBindSt } from '../../../model/data/v2/SlImmBindStateV2';
import { ImmBaseData } from '../../../model/data/v2/ImmBaseData';

const TAG = 'ImmersiveDataVm';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

/**
 * 沉浸模块数据接收处理业务
 */
export class ImmersiveDataVm extends NotificationDataVm implements IImmersiveDataVm {
  /**
   * 业务名
   */
  protected vmName: string = TAG;

  /**
   * 业务注入器
   */
  protected vmInjector: IImmersiveNtfVmInjector;

  /**
   * 全量通知集
   */
  private readonly ntfList: NotificationArray = new NotificationArray();

  /**
   * 全量沉浸态数据集
   */
  private readonly immList: NotificationArray = new NotificationArray();

  /**
   * 全量通知集
   * groupKey -> NotificationBase
   */
  private readonly ntfMap: LimitMap<string, NotificationBase> = new LimitMap();

  /**
   * 全量通知索引集
   * groupKey -> index
   */
  private readonly indexMap: Map<string, number> = new Map();

  /**
   * 异常数据记录groupKey
   */
  private readonly recordWrongSet: LimitSet<string> = new LimitSet();

  /**
   * 锁屏面板锁屏时间戳
   */
  private slLockTime: number = Number.MAX_VALUE;

  /**
   * 是否已初始化
   */
  private hasInit: boolean = false;

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    super(vmInjector);
    this.vmInjector = vmInjector;
  }

  init(): void {
    if (this.hasInit) {
      return;
    }
    this.slLockTime = ImmersiveComHelper.getSysTime();
    log.showWarn(TAG, `data init: ${this.slLockTime}`);
    this.hasInit = true;
    // 优先业务初始化，其次数据初始化
    this.getLifeCycleList()?.forEach((life) => life?.init());
    super.init();
  }

  destroy(): void {
    if (this.hasInit) {
      this.hasInit = false;
      this.ntfList.clear();
      this.immList.clear();
      this.getLifeCycleList()?.forEach((life) => life?.destroy());
      super.destroy();
      // 清空数据绑定VM
      this.vmInjector?.deleteVmByAllNtf();
      immersiveKgMgr.setDefaultImmersiveType();
    }
  }

  getDataIndexMap(): Map<string, number> {
    return this.indexMap;
  }

  getDataIndex(groupKey?: string | undefined): number {
    return this.indexMap.get(groupKey ?? '') ?? -1;
  }

  getImmList(): NotificationArray {
    return this.immList;
  }

  /**
   * 单个数据时，允许解除组通知
   *
   * @returns true解除组通知
   */
  protected isResetGroup(): boolean {
    return true;
  }

  /**
   * 数据缓存拦截
   *
   * @param incomingNtf 新来通知
   * @returns 新成组通知
   */
  protected saveNtf(incomingNtf: NotificationBase): NotificationBase | undefined {
    // 检验通知有效性
    if (this.checkDataValid(incomingNtf)) {
      return super.saveNtf(incomingNtf);
    }
    return undefined;
  }

  /**
   * 移除通知拦截
   *
   * @param incomingNtf 移除通知
   * @returns 被移除通知
   */
  protected clearNtf(incomingNtf: NotificationBase): NotificationBase | undefined {
    // 如果当前无该条通知，则不涉及数据移除
    let oldData = this.getNtfByHashCode(incomingNtf?.hashCode);
    if (oldData) {
      return super.clearNtf(incomingNtf);
    }
    return undefined;
  }

  /**
   * 清除异常数据，一般置顶状态变化时，groupKey会变化
   *
   * @param incomingNtf 新数据
   */
  protected deleteWrongGroup(incomingNtf: NotificationBase): void {
    // 取出老数据
    let oldData = this.getNtfByHashCode(incomingNtf?.hashCode);
    super.deleteWrongGroup(incomingNtf);
    // 如果为三方实况超时，则及时清除数据
    if (incomingNtf.isLiveView() && incomingNtf.card.isOtherCard() && incomingNtf.isEnd) {
      this.clearNtf(incomingNtf);
    }
    // 及时删除异常数据，同时记录新数据groupKey
    let oldGroupKey = oldData?.groupKey;
    if (oldGroupKey) {
      // 旧数据未删除，不做记录
      let oldGroupData = this.getNtfByGroupKey(oldGroupKey);
      if (oldGroupData) {
        return;
      }
      this.getDataShareList()?.forEach((share) => share?.onDelWrongData?.(oldGroupKey!));
      this.recordWrongSet.add(incomingNtf.groupKey);
    }
  }

  /**
   * 数据刷新回调
   *
   * @param dataRecord 数据刷新记录仪
   */
  protected onDataChange(dataRecord: NotificationRefreshRecord): void {
    // 提前记录变化数据
    this.checkWrongData(dataRecord);
    let changeArr = this.createDataArr(dataRecord.changeDataSet);
    let updateArr = this.createDataArr(dataRecord.updateDataSet);
    // 滞后刷新全量数据
    this.refreshNtfList();
    let allArr: NotificationArray = new NotificationArray(...this.ntfList);
    let dataShare: IImmDataShare = { isDataRefresh: dataRecord.isDataRefresh, allDataArr: allArr,
      dataRefreshType: dataRecord.dataRefreshType, changeDataArr: changeArr, updateDataArr: updateArr };
    let shareWrap: ImmDataShareWrap = ImmDataShareWrap.wrap(dataShare);
    // 检测自动亮屏
    shareWrap.setAutoScreenOn(this.checkAutoScreenOn(shareWrap));
    // 数据分享回调
    this.getDataShareList()?.forEach((share) => share?.onDataChange(shareWrap));
  }

  /**
   * 刷新通知数据列表
   */
  private refreshNtfList(): void {
    this.ntfList.clear();
    this.immList.clear();
    this.ntfMap.clear();
    this.indexMap.clear();
    this.groupForEach((ntf) => {
      this.ntfList.push(ntf);
      this.ntfMap.set(ntf?.groupKey, ntf);
    });
    this.ntfList.sort();
    // 索引记录
    this.ntfList.forEach((ntf, index) => {
      this.indexMap.set(ntf?.groupKey, index);
      // 沉浸态数据集
      if (ImmBaseData.hasImmCard(ntf)) {
        this.immList.push(ntf);
      }
    });
  }

  private checkWrongData(dataRecord: NotificationRefreshRecord): void {
    // 兼容处理错误数据，错误数据按更新处理，非新增处理
    this.recordWrongSet.forEach((groupKey) => {
      dataRecord.changeDataSet?.delete(groupKey);
      dataRecord.updateDataSet?.add(groupKey);
    });
    this.recordWrongSet.clear();
  }

  private createDataArr(groupKeyArr?: Set<string>): NotificationArray {
    // 根据groupKey取出对应通知数据
    let resultArr: NotificationArray = new NotificationArray();
    groupKeyArr?.forEach((groupKey) => {
      // 兼容删除数据场景
      let data = this.getNtfByGroupKey(groupKey) ?? this.ntfMap.get(groupKey);
      if (data) {
        resultArr.push(data);
      }
    });
    resultArr.sort();
    return resultArr;
  }

  private checkAutoScreenOn(dataShareWrap: ImmDataShareWrap): boolean {
    // 非熄屏状态，不涉及亮屏
    if (slImmBindSt.isCurScreenOn()) {
      return false;
    }
    // 新增/更新数据场景才允许自动亮屏
    if (!(dataShareWrap.isDataChange() && (dataShareWrap.isAdd() || dataShareWrap.isUpdate()))) {
      return false;
    }
    // 数据更新场景
    let isUpdate = dataShareWrap.isUpdate();
    let isAutoScreenOn = slImmBindSt.isNtfAutoScreenOn();
    let result = dataShareWrap.getDataChangeArr()?.find((ntf) => {
      // ANS标识不亮屏
      let isAnsScreenOn = ntf.remindConfig?.isOnScreenEnable();
      if (!isAnsScreenOn) {
        return false;
      }
      // voip亮屏
      let isVoipScreenOn = ntf.controlConfig?.isExtraScreenOn();
      // 强提醒亮屏
      let isRemindScreenOn = ntf.isLiveView() && ntf.card?.isOtherCard() && ntf.remindConfig?.isBannerEnable();
      log.showInfo(TAG, `checkAutoScreenOn: ${isAutoScreenOn}, ${isVoipScreenOn}, ${isRemindScreenOn}, ${isUpdate}`);
      // 异步亮屏
      if (((isAutoScreenOn || isVoipScreenOn) && !isUpdate) || isRemindScreenOn) {
        ImmersiveComHelper.startNtfAutoScreenOn();
        return true;
      }
      return false;
    });
    return Boolean(result);
  }

  /**
   * 检测数据有效性
   *
   * @param incomingNtf 数据
   * @returns true有效
   */
  private checkDataValid(incomingNtf: NotificationBase): boolean {
    if (!incomingNtf) {
      log.showWarn(TAG, 'checkDataValid invalid data.');
      return false;
    }
    // Oobe阶段，锁屏不显示通知
    if (SCBOobeManager.isOobeActivated()) {
      log.showWarn(TAG, `checkDataValid oobe is active: ${incomingNtf.hashCode}`);
      return false;
    }
    // 系统实况不在锁屏显示
    if (incomingNtf.isFromSystemApp && incomingNtf.isHiddenInKg) {
      log.showWarn(TAG, `checkDataValid hide in kg: ${incomingNtf.hashCode}`);
      return false;
    }
    // 锁屏通知开关限制
    if (!incomingNtf.isLockScreenEnable) {
      log.showWarn(TAG, `checkDataValid lock screen disable: ${incomingNtf.hashCode}`);
      return false;
    }
    // 实况超时限制，直接锁屏移除
    if (incomingNtf.isLiveView() && incomingNtf.card.isOtherCard() && incomingNtf.isEnd) {
      log.showWarn(TAG, `checkDataValid other live end: ${incomingNtf.hashCode}`);
      return false;
    }
    log.showInfo(TAG, `checkDataValid end ${incomingNtf.hashCode}: ${incomingNtf.isOngoing},
      ${incomingNtf.deliveryTime}, ${this.slLockTime}, ${incomingNtf.remindConfig?.flags}`);
    // ongoing限制或通知发送时刻限制
    return incomingNtf.isOngoing || (incomingNtf.deliveryTime > this.slLockTime);
  }

  private getLifeCycleList(): IImmLifeCycleVmArray {
    return this.vmInjector?.getImmLifeCycleVmList();
  }

  private getDataShareList(): IImmDataShareVmArray {
    return this.vmInjector?.getImmDataShareVmList();
  }
}