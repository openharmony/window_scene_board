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
import { DeviceHelper, GlobalContext, sSettingsUtil } from '@ohos/frameworkwrapper';

// 已知加载QuickToggleController，会初始化BrightnessOptionUtils的提亮压暗参数
// 这里采用懒加载，避免过早加载BrightnessOptionUtils，导致其静态参数过早初始化，导致异常
import lazy {
  QuickToggleController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/QuickToggleController';
import { ToggleData } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/Constants';
import { ResUtils } from '@ohos/windowscene';
import { ModeChangeUtils } from '@ohos/frameworkwrapper/src/main/ets/utils/ModeChangeUtils';


const TAG = 'ToggleDataBridger';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);
const QXS_TOGGLE_INDEX_SETTING_KEY = 'settings.control.qxs_toggle_index_data';
const IN_CANDIDATE_GRID = -1;
const NOT_INIT = -2;
const DOUBLE = 2;
const QUICK_TOGGLE_MAX = 20;
const QUICK_TOGGLE_MIN = 4;
/**
 * 数据组织方式
 * toggle,index,ownership;toggle,index,ownership
 */
enum ToggleOwnership {
  PC_MODE = 1,
  PAD_MODE,
  COMMON
}

class ToggleWrapper {
  private static TOGGLE_INDEX_LENGTH = 3;
  public toggleSlot: string = '';
  public index: number = IN_CANDIDATE_GRID;
  public ownership: ToggleOwnership = ToggleOwnership.COMMON;

  constructor(toggleSlot: string, index: number, ownership: ToggleOwnership) {
    this.toggleSlot = toggleSlot;
    this.index = index;
    this.ownership = ownership
  }

  public static serialize(wrapper: ToggleWrapper): string {
    let res = '';
    res += wrapper.toggleSlot + ',';
    res += wrapper.index.toString() + ',';
    res += wrapper.ownership.toString();
    return res;
  }

  public static deserialize(data: string): ToggleWrapper | null {
    let jsonData = data.split(',');
    if (jsonData.length !== ToggleWrapper.TOGGLE_INDEX_LENGTH) {
      return null;
    }
    return new ToggleWrapper(jsonData[0], Number(jsonData[1]), Number(jsonData[2]));
  }
}

/**
 * 用于qxs pc模式和pad模式数据重排和同步
 */
export class ToggleDataBridger {
  private static mInstance: ToggleDataBridger;
  /**
   * db里读取出的所有quickToggle信息
   */
  private allQuickToggles: Map<string, ToggleWrapper> = new Map();
  private isPcMode: boolean = DeviceHelper.is2In1DevicePcType();
  private isPadMode: boolean = DeviceHelper.is2In1DevicePadType();
  private padModeAllToggles: string[] = [];
  private pcModeAllToggles: string[] = [];
  private isInit: boolean = false;
  private context?: Context;
  public init = () => {
    if (!ModeChangeUtils.isSupportWindowPcModeSwitch()) {
      log.showError(TAG, `ToggleDataBridger ${ModeChangeUtils.isSupportWindowPcModeSwitch()}`);
      return;
    }
    if (this.isInit) {
      log.showWarn(TAG, `ToggleDataBridger already init`);
      return;
    }
    this.context = GlobalContext.getContext() as Context;
    this.pcModeAllToggles = ResUtils.getInnerString($r('app.string.pc_mode_toggle_data_all'))?.split(',');
    this.padModeAllToggles = ResUtils.getInnerString($r('app.string.pad_mode_toggle_data_all'))?.split(',');
    QuickToggleController.getInstance().onToggleDataChange().then(() => {
      QuickToggleController.getInstance().preSaveQuickToggleDataCb = (data: string[]) => {
        this.preSaveQuickToggleData(data);
      }
      this.initAllToggleWrappers();
      this.initToggleDataIndex();
    })
  }

  public static getInstance(): ToggleDataBridger {
    if (!ToggleDataBridger.mInstance) {
      ToggleDataBridger.mInstance = new ToggleDataBridger();
    }
    return ToggleDataBridger.mInstance;
  }

  private initAllToggleWrappers(): void {
    // pcmode特有的图标
    const pcModeToggles = this.pcModeAllToggles.filter((toggleSlot: string) => {
      return !this.padModeAllToggles.includes(toggleSlot);
    });
    // padmode特有的图标
    const padModeToggles = this.padModeAllToggles.filter((toggleSlot: string) => {
      return !this.pcModeAllToggles.includes(toggleSlot);
    });
    // 共有的图标
    const commonToggles = this.pcModeAllToggles.filter((toggleSlot: string) => {
      return this.padModeAllToggles.includes(toggleSlot);
    });
    const pcModeWrappers = this.initWrappers(pcModeToggles, ToggleOwnership.PC_MODE);
    const padModeWrappers = this.initWrappers(padModeToggles, ToggleOwnership.PAD_MODE);
    const commonWrappers = this.initWrappers(commonToggles, ToggleOwnership.COMMON);
    this.saveToggleIndexCache([...pcModeWrappers, ...padModeWrappers, ...commonWrappers]);

    let jsonData = this.queryUniqueToggleIndex(QXS_TOGGLE_INDEX_SETTING_KEY);
    if (jsonData) {
      let allToggleWrappers = this.deserialize(jsonData);
      this.saveToggleIndexCache(allToggleWrappers);
    }
    this.saveToggleIndex(QXS_TOGGLE_INDEX_SETTING_KEY, jsonData);
  }

  private initWrappers(toggles: string[], ownership: ToggleOwnership): ToggleWrapper[] {
    let res: ToggleWrapper[] = [];
    for (let i = 0; i < toggles.length; i++) {
      let wrapper = new ToggleWrapper(toggles[i], NOT_INIT, ownership);
      res.push(wrapper);
    }
    return res;
  }

  private preSaveQuickToggleData(data: string[]): void {
    // 1.更新图标位置
    for (let toggle of this.allQuickToggles.values()) {
      let index = data.findIndex((toggleSlot: string) => {
        return toggleSlot === toggle.toggleSlot;
      });
      if (index >= 0) {
        toggle.index = index;
      } else if (!this.isOtherMode(toggle.ownership)) {
        toggle.index = IN_CANDIDATE_GRID;
      }
    }
    // 2.保存数据库
    this.saveToggleWrapperCache();
  }

  private initToggleDataIndex(): void {
    let toggleData: ToggleData = QuickToggleController.getInstance().getToggleData();
    // 查询数据库所有的图标数据，需要做刷新操作，更新缓存，多删少补
    let wrappers: ToggleWrapper[][] = this.initToggleWrapper(toggleData);
    if (wrappers.length !== DOUBLE) {
      log.showError(TAG, 'initToggleDataIndex wrappers length invalid2');
      return;
    }
    let reorderWrappers = this.filterOrAddToggle(wrappers);
    this.saveToggleIndexCache(reorderWrappers[0]);
    this.saveToggleIndexCache(reorderWrappers[1]);
    log.showInfo(TAG, `initToggleDataIndex reorderWrappers[0] ${JSON.stringify(reorderWrappers[0])}`);
    QuickToggleController.getInstance().saveQuickToggleData(reorderWrappers[0].map((toggle) => toggle.toggleSlot));
    QuickToggleController.getInstance().onToggleDataChange();
  }

  private saveToggleWrapperCache(): void {
    let dbItem: ToggleWrapper[] = [];
    for (let item of this.allQuickToggles.values()) {
      dbItem.push(item);
    }
    let jsonData: string = this.serialize(dbItem);
    log.showInfo(TAG, `saveToggleWrapperCache ${jsonData}`);
    this.saveToggleIndex(QXS_TOGGLE_INDEX_SETTING_KEY, jsonData);
  }

  private initToggleWrapper(toggleData: ToggleData): ToggleWrapper[][] {
    let res: ToggleWrapper[][] = [[], []];
    for (let i = 0; i < toggleData.quickToggle.length; i++) {
      let toggleSlot = toggleData.quickToggle[i];
      let toggleWrapper = this.allQuickToggles.get(toggleSlot);
      if (toggleWrapper) {
        let ownerShip = toggleWrapper.ownership;
        let wrapper = new ToggleWrapper(toggleSlot, i, ownerShip);
        res[0].push(wrapper);
      }
    }
    for (let i = 0; i < toggleData.otherToggle.length; i++) {
      let toggleSlot = toggleData.otherToggle[i];
      let toggleWrapper = this.allQuickToggles.get(toggleSlot);
      if (toggleWrapper) {
        let ownerShip = toggleWrapper.ownership;
        let wrapper = new ToggleWrapper(toggleSlot, IN_CANDIDATE_GRID, ownerShip);
        res[1].push(wrapper);
      }
    }
    return res;
  }

  private isCommonMode(ownership: ToggleOwnership): boolean {
    return ownership === ToggleOwnership.COMMON;
  }

  private isUniqueMode(ownership: ToggleOwnership): boolean {
    if (ownership === ToggleOwnership.COMMON) {
      return false;
    }
    if ((ownership === ToggleOwnership.PC_MODE && this.isPcMode) ||
      (ownership === ToggleOwnership.PAD_MODE && this.isPadMode)) {
      return true;
    }
    return false;
  }

  private isOtherMode(ownership: ToggleOwnership): boolean {
    if (ownership === ToggleOwnership.COMMON) {
      return false;
    }
    if ((ownership === ToggleOwnership.PC_MODE && this.isPadMode) ||
      (ownership === ToggleOwnership.PAD_MODE && this.isPcMode)) {
      return true;
    }
    return false;
  }

  /**
   * 多删少补
   * 遵循原则：
   * 1.当前模式特有的图标显示在控制中心的位置应该固定
   * 2.超出当前最大显示图标数量，则将显示图标最后的图标移到备选库
   * 3.如果当前显示图标数量少于最小显示图标数量，则从备选库添加一个图标到控制中心
   *
   * @param wrappers 更新完ownership的图标信息
   * @returns 排好序，且过滤不可添加的选中库图标和备选库图标
   */
  private filterOrAddToggle(wrappers: ToggleWrapper[][]): ToggleWrapper[][] {
    // 过滤出公共的图标
    let selectedToggles = wrappers[0].filter((toggle) => {
      return this.isCommonMode(toggle.ownership);
    });
    let candidateToggles = wrappers[1].filter((toggle) => {
      return this.isCommonMode(toggle.ownership);
    });
    let selectedLength = selectedToggles.length;
    let uniqueToggles: ToggleWrapper[] = [];
    for (let item of this.allQuickToggles.values()) {
      // 插入当前模式特有的图标
      if (this.isUniqueMode(item.ownership) && item.index >= 0 &&
      QuickToggleController.getInstance().createToggleModel(item.toggleSlot) &&
        !this.includes(uniqueToggles, item)) {
        uniqueToggles.push(item);
        selectedLength++;
      }
    }
    uniqueToggles.sort((item1: ToggleWrapper, item2: ToggleWrapper) => {
      return item1.index - item2.index;
    });
    for (let i = 0; i < uniqueToggles.length; i++) {
      let uniqueToggle = uniqueToggles[i];
      selectedToggles.splice(uniqueToggle.index, 0, uniqueToggle);
    }
    let allToggles = [...selectedToggles, ...candidateToggles];
    selectedLength = (selectedLength > QUICK_TOGGLE_MAX) ? QUICK_TOGGLE_MAX : selectedLength;
    selectedLength = (selectedLength < QUICK_TOGGLE_MIN) ? QUICK_TOGGLE_MIN : selectedLength;
    for (let i = 0; i < allToggles.length; i++) {
      let toggle = allToggles[i];
      toggle.index = i < selectedLength ? i : IN_CANDIDATE_GRID;
      this.allQuickToggles.set(toggle.toggleSlot, toggle);
    }
    log.showInfo(TAG, `filterOrAddToggle allToggles ${JSON.stringify(allToggles)}`);
    return [allToggles.slice(0, selectedLength), allToggles.slice(selectedLength, allToggles.length)];
  }

  private includes(allToggles: ToggleWrapper[], toggle: ToggleWrapper): boolean {
    let index = allToggles.findIndex((item) => {
      return item.toggleSlot === toggle.toggleSlot;
    });
    return index >= 0;
  }

  private saveToggleIndexCache(wrappers: ToggleWrapper[]): void {
    for (let wrapper of wrappers) {
      let toggle = this.allQuickToggles.get(wrapper.toggleSlot);
      if (toggle) {
        toggle.index = wrapper.index;
        continue;
      }
      this.allQuickToggles.set(wrapper.toggleSlot, wrapper);
    }
  }

  private saveToggleIndex(settingKey: string, jsonData: string): void {
    sSettingsUtil.setSecureValue(settingKey, jsonData, this.context);
  }

  private queryUniqueToggleIndex(settingKey: string): string {
    return sSettingsUtil.getSecureValue(settingKey, '', this.context);
  }

  private serialize(wrappers: ToggleWrapper[]): string {
    let res: string = '';
    for (let item of wrappers) {
      res += ToggleWrapper.serialize(item) + ';';
    }
    res = res.slice(0, res.length - 1);
    return res;
  }

  private deserialize(data: string): ToggleWrapper[] {
    let wrappers: ToggleWrapper[] = [];
    let wrapperStrs: string[] = data.split(';');
    if (wrapperStrs.length <= 0) {
      return wrappers;
    }
    for (let wrapperStr of wrapperStrs) {
      let wrapper = ToggleWrapper.deserialize(wrapperStr);
      if (wrapper) {
        wrappers.push(wrapper);
      }
    }
    return wrappers;
  }
}