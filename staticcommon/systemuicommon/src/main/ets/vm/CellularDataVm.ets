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
import { Singleton } from '../utils/Singleton';
import sim from '@ohos.telephony.sim';
import { LogDomain, Logger } from '@ohos/basicutils';
import { data, observer } from '@kit.TelephonyKit';
import settings from '@ohos.settings';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { connection, statistics } from '@kit.NetworkKit';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';

const MAX_SIM_COUNT_LIMIT: number = 2;
const TAG = 'CellularDataVm'
const log: Logger = Logger.getLogHelper(LogDomain.NC);

@ObservedV2
export class CellularDataVm {
  /**
   * 流量套餐map<simId, 流量套餐信息>
   */
  @Trace private dataPlanMap: Map<number, DataPlanInfo> = new Map();
  /**
   * 卡槽与SIM卡关系map
   */
  @Trace private slotToSimMap: Map<number, number> = new Map();
  /**
   * 流量套餐查询callback
   */
  @Trace private dataPlanQueryCallbacks: Set<Function> = new Set();
  /**
   * 当前默认移动数据卡
   */
  @Trace private defaultCellularDataSimId: number = 0;

  @Singleton.decorate()
  public static get instance(): CellularDataVm {
    return new CellularDataVm();
  }

  private commonEventSubscriber?: commonEventManager.CommonEventSubscriber;

  async init() {
    try {
      log.showInfo(TAG, `init`);
      // 首次手动获取默认移动卡，后续移动卡切换通过订阅感知
      this.defaultCellularDataSimId = data.getDefaultCellularDataSimId();
      // 订阅默认移动网络
      let retry = 3;
      while (retry > 0) {
        const success = await this.registerDefaultNet();
        if (success) {
          retry = 0;
        }
        retry--;
      }

      for (let i = 0; i < this.getMaxSimCount(); i++) {
        try {
          // 订阅流量套餐信息
          this.registerDataPlanObserver(i);
        } catch (e) {
          log.showError(TAG, `observe sim ${i} failed, ${e}`);
        }
      }
      log.showWarn(TAG, `default cellular data simId: ${this.defaultCellularDataSimId}`);
    } catch (e) {
      log.showWarn(TAG, `init CellularDataVm error. ${e}`);
    }
  }

  destroy() {
    log.showInfo(TAG, `destroy`);
    commonEventManager.unsubscribe(this.commonEventSubscriber, (err: BusinessError) => {
      this.commonEventSubscriber = undefined;
    });
  }

  private getMaxSimCount() {
    let maxSimCount = sim.getMaxSimCount();
    if (maxSimCount < 0 || maxSimCount > MAX_SIM_COUNT_LIMIT) {
      log.showError(TAG, `invalid max sim count ${maxSimCount}`);
      maxSimCount = 0;
    }
    return maxSimCount;
  }

  /**
   * 当前流量卡是否开启流量显示
   * 显示条件：1、SIM卡处于READY状态；2、SIM卡开启了流量显示开关
   */
  @Computed
  public get isShowData(): boolean {
    const dataPlan = this.dataPlanMap.get(this.defaultCellularDataSimId);
    if (dataPlan) {
      log.showInfo(TAG, `isShowData: ${dataPlan.trafficSwitch}`);
      return dataPlan.trafficSwitch;
    } else {
      log.showInfo(TAG, `simId: ${this.defaultCellularDataSimId} is not show Data`);
      return false;
    }
  }

  /**
   * 刷新流量套餐信息
   */
  public async refreshDataPlanInfo(): Promise<void> {
    const simId = this.defaultCellularDataSimId;
    const dataPlan = this.dataPlanMap.get(simId);
    if (!dataPlan) {
      log.showWarn(TAG, `can not find data plan info by simId: ${simId}`);
      return undefined;
    }
    const totalData = this.unitConversion(dataPlan.totalBytes);
    const todayUseData = await this.getTodayUseData(simId);
    const monthlyRemainData = await this.getMonthlyRemainData(simId);
    this.notifyDataPlanRefreshCallbacks({
      startDay: dataPlan.startDay,
      totalData: totalData,
      todayUseData: todayUseData,
      monthlyRemainData: monthlyRemainData
    })
  }

  private async getTodayUseData(simId: number): Promise<DataInfo | undefined> {
    const now = new Date();
    const startDate = new Date(now.getFullYear(), now.getMonth(), now.getDate())
    const endDate = this.getNextDay(startDate);
    const monthlyUse = await this.queryDataInfo(startDate, endDate, simId);
    if (monthlyUse !== undefined) {
      return this.unitConversion(monthlyUse);
    } else {
      log.showWarn(TAG, `query today use data failed`);
      return undefined;
    }
  }

  private async getMonthlyRemainData(simId: number): Promise<DataInfo | undefined> {
    const dataPlan = this.dataPlanMap.get(this.defaultCellularDataSimId);
    if (!dataPlan) {
      log.showWarn(TAG, `get dataPlan failed. simId: ${this.defaultCellularDataSimId}`);
      return undefined;
    }
    const startDay = dataPlan.startDay;
    const currentDate = new Date();
    const startDate = this.calculateStartDate(currentDate, startDay);
    const endDate = this.getNextDay(currentDate);
    const monthlyUse = await this.queryDataInfo(startDate, endDate, simId);
    if (monthlyUse !== undefined) {
      return this.unitConversion(dataPlan.totalBytes - monthlyUse);
    } else {
      log.showWarn(TAG, `query mothly data failed`);
      return undefined;
    }
  }

  private async queryDataInfo(startDate: Date, endDate: Date, simId: number): Promise<number | undefined> {
    try {
      // 单位换算至秒
      const startTime = startDate.getTime() / 1000;
      const endTime = endDate.getTime() / 1000;
      log.showInfo(TAG,
        `query use Data start. simId: ${simId}, startData: ${startTime}, endDate: ${endTime}`);
      const netStateInfo = await statistics.getTrafficStatsByNetwork({
        type: connection.NetBearType.BEARER_CELLULAR,
        startTime: startTime,
        endTime: endTime,
        simId: simId,
      });
      // 用户使用流量 = 上行数据 + 下行数据
      let totalByte: number = 0;
      for (const entry of Object.entries(netStateInfo)) {
        const data = entry[1];
        totalByte += (data.rxBytes ?? 0) + (data.txBytes ?? 0);
      }
      log.showInfo(TAG, `query today use Data success. data: ${totalByte}`);
      return totalByte;
    } catch (e) {
      log.showError(TAG, `query data error. ${e}`);
      return undefined;
    }
  }

  /**
   * 单位转换
   */
  private unitConversion(data: number): DataInfo {
    let isNegative = false;
    if (data < 0) {
      isNegative = true;
    }
    let value = Math.abs(data);
    if (value <= 1024) {
      return { data: 0, unit: 'KB' };
    }
    const units = ['KB', 'MB', 'GB', 'TB'];
    value /= 1024;
    let unitIndex = 0;
    // 循环升级单位直到数值小于1024或达到最高单位
    while (value >= 1024 && unitIndex < units.length - 1) {
      value /= 1024;
      unitIndex++;
    }

    // 处理数值的小数部分
    if (Number.isInteger(value)) {
      return { data: isNegative ? -value : value, unit: `${units[unitIndex]}` };
    } else {
      // 保留两位小数，第三位四舍五入
      const roundedValue = Math.round(value * 100) / 100;
      return { data: isNegative ? -roundedValue : roundedValue, unit: `${units[unitIndex]}` };
    }
  }

  /**
   * 订阅流量套餐信息
   *
   * @param slotId 卡槽号
   */
  private async registerDataPlanObserver(slotId: number): Promise<void> {
    log.showInfo(TAG, `registerDataPlanObserver slotId: ${slotId}`);
    const context = GlobalContext.getContext();
    try {
      // 初始化：手动查询+订阅数据库
      const accountInfo = await sim.getSimAccountInfo(slotId);
      const simId = accountInfo.simId ?? 0;
      log.showInfo(TAG, `set slotId: ${slotId}, simId: ${simId}`);
      this.slotToSimMap.set(slotId, simId);
      this.dataPlanMap.set(simId, new DataPlanInfo());
      this.registerShowDataSwitch(simId, context);
      this.registerTotalData(simId, context);
      this.registerStartDay(simId, context);
      // 避免开机时获取默认SimId有问题，查询卡槽变化时也查询默认SimID
      this.defaultCellularDataSimId = data.getDefaultCellularDataSimId();
      log.showInfo(TAG, `registerDataPlanObserver default simId: ${this.defaultCellularDataSimId}`);
    } catch (e) {
      log.showWarn(TAG, `can not get sim Info. slotId: ${slotId}`);
    }
    // 非初始化：监听sim卡状态变化，重新查询+订阅新的数据库
    this.observerSimChange(slotId, context);
  }

  private async observerSimChange(slotId: number, context: Context): Promise<void> {
    observer.on('iccAccountInfoChange', async () => {
      log.showInfo(TAG, `iccAccountInfoChange`);
      try {
        const accountInfo = await sim.getSimAccountInfo(slotId);
        log.showInfo(TAG, `getSimAccountInfo success`);
        const simId = accountInfo.simId ?? 0;
        if (accountInfo.isActive) {
          log.showInfo(TAG, `set slotId: ${slotId}, simId: ${simId}`);
          this.slotToSimMap.set(slotId, simId);
          this.dataPlanMap.set(simId, new DataPlanInfo());
          this.registerShowDataSwitch(simId, context);
          this.registerTotalData(simId, context);
          this.registerStartDay(simId, context);
          this.refreshDataPlanInfo();
        } else {
          log.showInfo(TAG, `sim: ${simId} is not active`);
          this.slotToSimMap.delete(slotId);
          this.dataPlanMap.delete(simId);
          this.unRegisterShowDataSwitch(simId, context);
          this.unRegisterTotalData(simId, context);
          this.unRegisterStartDay(simId, context);
        }
        // sim变化时也查询默认SimID
        this.defaultCellularDataSimId = data.getDefaultCellularDataSimId();
        log.showInfo(TAG, `refreshDataPlanInfo default simId: ${this.defaultCellularDataSimId}`);
      } catch (e) {
        log.showWarn(TAG, `can not get sim info. slotId: ${slotId}`);
        // SIM卡无法识别场景场景，如：拔卡
        const simId = this.slotToSimMap.get(slotId);
        if (simId !== undefined) {
          this.dataPlanMap.delete(simId);
          this.unRegisterShowDataSwitch(simId, context);
          this.unRegisterTotalData(simId, context);
          this.unRegisterStartDay(simId, context);
        }
        this.slotToSimMap.delete(slotId);
      }
    })
  }

  private registerStartDay(simId: number, context: Context): void {
    log.showInfo(TAG, `registerStartDay. simId: ${simId}`);
    const startDayKey = `net_stats_${simId}_monthly_start_date`;
    const startDay = Number(settings.getValueSync(context, startDayKey, '1'));
    log.showInfo(TAG, `query from database key: ${startDayKey}, value: ${startDay} `)
    this.updateDataPlan(simId, undefined, undefined, startDay);
    settings.registerKeyObserver(context, startDayKey, settings.domainName.DEVICE_SHARED, () => {
      const startDay = Number(settings.getValueSync(context, startDayKey, '1'));
      log.showInfo(TAG, `query from database key: ${startDayKey}, value: ${startDay} `)
      this.updateDataPlan(simId, undefined, undefined, startDay);
    })
  }

  private unRegisterStartDay(simId: number, context: Context): void {
    const startDayKey = `net_stats_${simId}_monthly_start_date`;
    settings.unregisterKeyObserver(context, startDayKey, settings.domainName.DEVICE_SHARED);
  }

  private registerTotalData(simId: number, context: Context): void {
    log.showInfo(TAG, `registerTotalData. simId: ${simId}`);
    const totalDataKey = `net_stats_${simId}_monthly_limited_traffic`;
    const totalData = Number(settings.getValueSync(context, totalDataKey, '0'));
    log.showInfo(TAG, `query from database key: ${totalDataKey}, value: ${totalData}`);
    this.updateDataPlan(simId, undefined, totalData, undefined);
    settings.registerKeyObserver(context, totalDataKey, settings.domainName.DEVICE_SHARED, () => {
      const totalData = Number(settings.getValueSync(context, totalDataKey, '0'));
      log.showInfo(TAG, `query from database key: ${totalDataKey}, value: ${totalData}`);
      this.updateDataPlan(simId, undefined, totalData, undefined);
    });
  }

  private unRegisterTotalData(simId: number, context: Context): void {
    const totalDataKey = `net_stats_${simId}_monthly_limited_traffic`;
    settings.unregisterKeyObserver(context, totalDataKey, settings.domainName.DEVICE_SHARED);
  }

  private registerShowDataSwitch(simId: number, context: Context): void {
    log.showInfo(TAG, `registerShowDataSwitch. simId: ${simId}`);
    const showDataKey = `net_stats_${simId}_traffic_switch`;
    const isShowData = Number(settings.getValueSync(context, showDataKey, '0'));
    log.showInfo(TAG, `query from database key: ${showDataKey}, value: ${isShowData}`);
    this.updateDataPlan(simId, isShowData === 1, undefined, undefined);
    settings.registerKeyObserver(context, showDataKey, settings.domainName.DEVICE_SHARED, () => {
      const isShowData = Number(settings.getValueSync(context, showDataKey, '0'));
      log.showInfo(TAG, `query from database key: ${showDataKey}, value: ${isShowData}`);
      this.updateDataPlan(simId, isShowData === 1, undefined, undefined);
    });
  }

  public unRegisterShowDataSwitch(simId: number, context: Context): void {
    const showDataKey = `net_stats_${simId}_traffic_switch`;
    settings.unregisterKeyObserver(context, showDataKey, settings.domainName.DEVICE_SHARED);
  }

  private updateDataPlan(simId: number, isShowData?: boolean, totalData?: number, startDay?: number) {
    const dataPlan = this.dataPlanMap.get(simId);
    if (dataPlan) {
      if (isShowData !== undefined) {
        log.showInfo(TAG, `updateDataPlan isShowData: ${isShowData}`);
        dataPlan.trafficSwitch = isShowData;
      }
      if (totalData !== undefined) {
        log.showInfo(TAG, `updateDataPlan totalData: ${totalData}`);
        dataPlan.totalBytes = totalData;
      }
      if (startDay !== undefined) {
        log.showInfo(TAG, `updateDataPlan startDay: ${startDay}`);
        dataPlan.startDay = startDay;
      }
    } else {
      this.dataPlanMap.set(simId, new DataPlanInfo());
    }
  }

  private async registerDefaultNet(): Promise<boolean> {
    log.showInfo(TAG, `registerDefaultNet`);
    try {
      this.commonEventSubscriber = await commonEventManager.createSubscriber({
        events: ['usual.event.SIM.DEFAULT_MAIN_SUBSCRIPTION_CHANGED']
      });
      commonEventManager.subscribe(this.commonEventSubscriber, (err, event) => {
        if (err) {
          log.error(`Receive usual.event.SIM.DEFAULT_MAIN_SUBSCRIPTION_CHANGED error: ${err?.code} ${err?.message}`);
          return;

        }
        const properties = event.parameters;
        log.showInfo(TAG, `chenliang data: ${event.data}, properties: ${properties}`);
        if (!properties) {
          return;
        }
        if (Reflect.has(properties, 'simId')) {
          const simId = Reflect.get(properties, 'simId') as number;
          log.showInfo(TAG, `default net card change ${this.defaultCellularDataSimId} -> ${simId}`)
          if (simId !== this.defaultCellularDataSimId) {
            this.defaultCellularDataSimId = simId;
            this.refreshDataPlanInfo();
          }
        }
      })
      return true;
    } catch (e) {
      log.showWarn(TAG, `registerDefaultNet failed. ${e}`)
      return false;
    }
  }

  private getNextDay(currentDate: Date): Date {
    const dayOfMonth = currentDate.getDate();
    const month = currentDate.getMonth();
    const year = currentDate.getFullYear();
    return new Date(year, month, dayOfMonth + 1);
  }

  /**
   * 根据套餐设置的开始日期（日）和当前日期计算本次套餐统计的实际开始时间
   * 如果套餐设置开始日期 < 当前日期，套餐开始时间 = 本月套餐设置的开始日期
   * 如果套餐设置开始日期 > 当前日期，套餐开始时间 = 上月套餐设置的开始日期（如果套餐设置的开始日期 > 上月最大天数，则自动换算至上月最后一天）
   *
   * @param dayOfMonth 日
   * @param month 月
   * @param year 年
   * @param startDay 套餐设置的开始日期（日）
   * @returns 本次套餐实际开始日期
   */
  private calculateStartDate(currentDate: Date, startDay: number): Date {
    const dayOfMonth = currentDate.getDate();
    const month = currentDate.getMonth();
    const year = currentDate.getFullYear();
    log.showInfo(TAG, `currentDate ${year}-${month}-${dayOfMonth}`)
    const maxDay = this.getMaxDayOfYearMonth(year, month);
    const realStartDay = Math.min(startDay, maxDay);
    log.showInfo(TAG, `realStartDay:${realStartDay}, dayOfMonth:${maxDay}`);
    let startDate: Date;
    if (dayOfMonth < realStartDay) {
      // 套餐开始日期大于当前日期，则从上个月开始算
      if (month === 0) {
        // 当前月份为1月的情况，套餐开始月份则为上一年的12月startDay号
        startDate = new Date(year - 1, 11, realStartDay);
      } else {
        let prevMaxDay = this.getMaxDayOfYearMonth(year, month - 1);
        startDate = new Date(year, month - 1, Math.min(startDay, prevMaxDay));
      }
    } else {
      startDate = new Date(year, month, realStartDay);
    }
    return startDate;
  }

  private getMaxDayOfYearMonth(year: number, month: number): number {
    let date = new Date(year, month, 1);
    date.setMonth(date.getMonth() + 1);
    date.setDate(0);
    return date.getDate();
  }

  public registerDataPlanRefreshCallback(callback: Function): void {
    log.showInfo(TAG, `registerDataPlanRefreshCallback ${callback.name}`);
    this.dataPlanQueryCallbacks.add(callback);
  }

  public unRegisterDataPlanRefreshCallback(callback: Function): void {
    log.showInfo(TAG, `unRegisterDataPlanRefreshCallback ${callback.name}`);
    this.dataPlanQueryCallbacks.delete(callback);
  }

  private notifyDataPlanRefreshCallbacks(dataInfo: NtfDisplayDataInfo): void {
    this.dataPlanQueryCallbacks.forEach(callback => {
      log.showInfo(TAG, `notifyDataPlanRefreshCallbacks ${callback.name}`);
      try {
        callback(dataInfo);
      } catch (e) {
        log.showWarn(TAG, `notifyDataPlanRefreshCallbacks ${callback.name} ${e}`);
      }

    })
  }
}

/**
 * 流量套餐信息
 */
@ObservedV2
export class DataPlanInfo {
  /**
   * 流量显示开关
   */
  @Trace public trafficSwitch: boolean = false;
  /**
   * 套餐总量，单位Byte
   */
  @Trace public totalBytes: number = 0;
  /**
   * 套餐开始日期，
   */
  @Trace public startDay: number = 1;
}

/**
 * 流量信息
 */
@ObservedV2
export class DataInfo {
  @Trace public data: number = 0;
  @Trace public unit: string = 'KB';
}

/**
 * 通知中心流量显示数据
 */
@ObservedV2
export class NtfDisplayDataInfo {
  @Trace public startDay?: number;
  @Trace public totalData?: DataInfo;
  @Trace public todayUseData?: DataInfo;
  @Trace public monthlyRemainData?: DataInfo;
}