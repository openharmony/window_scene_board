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

import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
} from '@ohos/basicutils';
import {
  ResUtils,
  windowMgr
} from '@ohos/windowscene';
import {
  PluginSlot,
  HiSysEventUtil,
  EvtBus,
  InputMethodEvent, GlobalContext,
  sSettingsUtil,
} from '@ohos/frameworkwrapper';
import InputMethodModel from '../model/InputMethodModel';
import inputMethod from '@ohos.inputMethod';
import InputMethodSubtype from '@ohos.InputMethodSubtype';
import {
  SwitchType,
  ReportType,
  InputMethodInfo,
  InputMethodSubtypeInfo,
  InputMethodItemType,
  InputMethodItemChangeListener,
  StateChangeListener
} from '../common/Constants';
import ResourceManager from '@ohos.resourceManager';
import { BusinessError, Callback } from '@ohos.base';
import { commonEventManager } from '@kit.BasicServicesKit';
import settings from '@ohos.settings';
import { Context } from '@kit.AbilityKit';
import { image } from '@kit.ImageKit';
import { LanguageCompare, LanguageCompareUtils } from '../common/Utils';
import InputMethodUtils from '@ohos/inputmethodcomponent/src/main/ets/default/common/InputMethodUtils';

const TAG = 'InputMethodPanelViewModel';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const DEFAULT_INIT_TIMES = 5;
const WAIT_SWITCH_INTERVAL = 100;
const sleep = (delay: number): Promise<number> => new Promise((resolve) => setTimeout(resolve, delay));
const SETTINGS_INPUTMETHOD_KEY = 'settings.input.ACTIVATED_AND_ADDED_INPUT_METHOD_SUB_MODE';

export class InputMethodPanelViewModel {
  /**
   * 更新二级界面大小
   */
  mUpdatePanelWindowListeners = new Set<InputMethodItemChangeListener>();
  /**
   * 二级界面是否显示，状态更新监听
   */
  mStateChangeListeners = new Set<StateChangeListener>();

  private mIsStart: boolean = false;
  private mInputMethodList: InputMethodInfo[] = [];
  private mLanguageList: InputMethodSubtypeInfo[] = [];
  private mInputSetting: Promise<inputMethod.InputMethodSetting | undefined> | undefined  = undefined;
  private mCurrentSubtype?: InputMethodSubtypeInfo;
  // 输入法进程拉起标志
  private mIsInputMethodReady: boolean = false;
  private fullLanguageList: Array<InputMethodSubtype> = [];
  private languageCompareUtils: LanguageCompareUtils = new LanguageCompareUtils();
  private retryCount: number = 0;
  private currentInputMethodSubtype: InputMethodSubtype | null = null;

  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      commonEventManager.Support.COMMON_EVENT_BOOT_COMPLETED
    ]
  };

  private mSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  context?: Context;

  constructor() {
    log.showInfo(`constructor`);
    try {
      this.mInputSetting = InputMethodUtils.queryInputMethodSetting();
      this.context = GlobalContext.getContext();
    } catch (error) {
      log.showError('[initInputMethodSetting]:error -> ' + JSON.stringify(error));
    }
  }

  public async initViewModel(): Promise<void> {
    if (this.mIsStart) {
      return;
    }
    log.showInfo('initViewModel');
    this.retryCount = 0;
    this.queryInputMethodSubtype();
  }

  private async queryInputMethodSubtype(): Promise<void> {
    this.retryCount += 1;
    if (this.retryCount > DEFAULT_INIT_TIMES) {
      log.showWarn(`[initViewModel] try over ${DEFAULT_INIT_TIMES} times, get input method finish. init successfully :${this.mIsInputMethodReady}`);
      return;
    }
    log.showInfo(`[initViewModel] is input method ready:${this.mIsInputMethodReady}, count:${this.retryCount}`);
    setTimeout(()=>{
      this.currentInputMethodSubtype = inputMethod.getCurrentInputMethodSubtype();
    }, 0);
    await sleep(0);
    this.mIsInputMethodReady = this.currentInputMethodSubtype !== null;
    if (!this.mIsInputMethodReady) {
      log.showInfo(`[initViewModel] no input method ready! Retry...`);
      setTimeout(() => {
        this.queryInputMethodSubtype();
      }, WAIT_SWITCH_INTERVAL);
      return;
    }
    InputMethodModel.startService();
    this.initInputMethodList();
    this.initLanguageList();
    this.mIsStart = this.mIsInputMethodReady;
  }

  public async updateMethodPropertyIcon(inputMethodInfo: InputMethodInfo,
    callback: Callback<image.PixelMap>): Promise<void> {
    if (inputMethodInfo?.property?.iconId === undefined) {
      log.showError(`updateMethodPropertyIcon get image failed, inputMethodInfo:${JSON.stringify(inputMethodInfo)}`);
      return;
    }

    // inputMethodProperty中未携带icon，从包管理获取
    if (inputMethodInfo?.property?.packageName === undefined) {
      log.showError(`getInputMethodImage failed, inputMethodInfo:${JSON.stringify(inputMethodInfo)}`);
      return;
    }
    log.showInfo(`InputMethod get image, inputMethodInfo:${JSON.stringify(inputMethodInfo)}`);
    let data = await ResUtils.getBundleInfo(TAG, inputMethodInfo?.property?.packageName);
    log.showInfo(`data: ${JSON.stringify(data)}`);
    let resource: ResourceManager.Resource = {
      bundleName: data.name,
      moduleName: data.entryModuleName,
      id: inputMethodInfo?.property?.iconId
    };
    ResUtils.getDrawableDescriptor(resource).then(icon => {
      log.showInfo(`updateMethodPropertyIcon getDrawableDescriptor success, icon:${JSON.stringify(icon.getPixelMap())}`);
      callback(icon.getPixelMap());
    }).catch((error: BusinessError) => {
      log.showError('updateMethodPropertyIcon getDrawableDescriptor error ' + error);
    });
  }

  public async updateInputMethodSubtypeIcon(inputMethodSubtype: InputMethodSubtypeInfo,
    callback: Callback<image.PixelMap>): Promise<void> {
    // inputMethodSubtype中未携带icon，从包管理获取
    if (inputMethodSubtype?.subtype?.iconId === undefined) {
      log.showError(`InputMethodSubtype get image failed, inputMethodInfo:${JSON.stringify(inputMethodSubtype)}`);
      return;
    }
    log.showInfo(`InputMethodSubtype get image, inputMethodSubtype:${JSON.stringify(inputMethodSubtype)}`);
    let data = await ResUtils.getBundleInfo(TAG, inputMethodSubtype?.subtype?.name);
    let resource: ResourceManager.Resource = {
      bundleName: inputMethodSubtype?.subtype?.name,
      moduleName: data.entryModuleName,
      id: inputMethodSubtype?.subtype?.iconId
    };
    ResUtils.getDrawableDescriptor(resource).then(icon => {
      log.showInfo(`InputMethodSubtype getDrawableDescriptor success, subtype:${JSON.stringify(inputMethodSubtype?.subtype)} icon:${JSON.stringify(icon)}`);
      callback(icon.getPixelMap());
    }).catch((error: BusinessError) => {
      log.showError('getDrawableDescriptor error code' + error?.code + ', message:' + error?.message);
    });
  }

  public async updateMethodPropertyTitle(inputMethodInfo: InputMethodInfo, callback: Callback<string>): Promise<void> {
    // inputMethodProperty中未携带label，从包管理获取
    if (inputMethodInfo?.property?.packageName === undefined) {
      log.showError(`getInputMethodImage failed, inputMethodInfo:${JSON.stringify(inputMethodInfo)}`);
      return;
    }
    log.showInfo(`getInputMethodImage, inputMethodInfo:${JSON.stringify(inputMethodInfo)}`);
    let data = await ResUtils.getBundleInfo(TAG, inputMethodInfo?.property?.packageName);
    log.showInfo(`data: ${JSON.stringify(data)}`);
    let resource: ResourceManager.Resource = {
      bundleName: data.name,
      moduleName: data.entryModuleName,
      id: Number(data?.appInfo?.labelId)
    };
    let title = await ResUtils.getOutString(resource);
    log.showInfo(`[updateMethodPropertyTitle] getString success, label:${title}`);
    callback(title);
  }

  public async setCurrentInputMethod(currentInputMethod: inputMethod.InputMethodProperty,
    needRefreshCurrentInputMethod: boolean): Promise<void> {
    if (needRefreshCurrentInputMethod) {
      // 更新当前输入法
      let inputMethod = {} as InputMethodInfo;
      inputMethod.vType = 'InputMethodInfo';
      inputMethod.property = currentInputMethod;
      log.showInfo(`[setCurrentInputMethod] mCurrentInputMethod:${JSON.stringify(inputMethod)}`);
      AppStorage.setOrCreate('currentInputMethod', inputMethod);
    }
    await this.refreshCurrentInputMethodTitle(currentInputMethod);
  }

  private async refreshCurrentInputMethodTitle(inputMethod: inputMethod.InputMethodProperty): Promise<void> {
    let packageName = inputMethod?.packageName;
    log.showInfo(`[getCurrentInputMethodTitle] current input method:${JSON.stringify(inputMethod)}`);
    if (packageName === undefined) {
      log.showError(`[initCurrentInputMethod] packageName is null`);
      return;
    }
    let data = await ResUtils.getBundleInfo(TAG, packageName);
    log.showInfo(`data: ${JSON.stringify(data)}`);
    let resource: ResourceManager.Resource = {
      bundleName: data.name,
      moduleName: data.entryModuleName,
      id: Number(data?.appInfo?.labelId)
    };

    // 通过BM更新当前输入法标题
    let label = ResUtils.getOutString(resource);
    log.showInfo(`[setCurrentInputMethod] getString success, label:${label}`);
    AppStorage.setOrCreate('currentInputMethodTitle', label);
  }

  public async getDefaultLanguageMode(language: string, callback: Callback<InputMethodSubtypeInfo>): Promise<void> {
    log.showInfo(`[getDefaultLanguageMode] language:${language}`);
    try {
      let mInputSetting = await this.mInputSetting;
      mInputSetting?.listCurrentInputMethodSubtype().then((data) => {
        if (data === undefined || data.length === 0) {
          log.showInfo('[getDefaultLanguageMode] get no method.');
          return;
        }
        this.mLanguageList = [];
        data?.forEach((item) => {
          this.addLanguageItem(item, this.mLanguageList);
        });
        this.mLanguageList.forEach((item) => {
          this.dealLowerLanguage(language, item, callback);
        });
      });
    } catch (err) {
      log.showError('[getDefaultLanguageMode] Failed to listInputMethodSubtype: code ' + err?.code + ', message:' +
        err?.message);
    }
  }

  /**
   * 注册系统公共事件
   */
  registerCommonEventChange(): void {
    if (this.mSubscriber) {
      return;
    }
    this.mSubscriber = commonEventManager.createSubscriberSync(this.subscribeInfo);
    if (this.mSubscriber === null) {
      log.showError('create subscriber error!');
      return;
    }
    commonEventManager.subscribe(this.mSubscriber,
      async (err: BusinessError, data: commonEventManager.CommonEventData) => {
        if (err) {
          log.showError('Can not handle common event, err: ' + err.code + 'err: ' + err.message);
          return;
        }
        if (data.event === commonEventManager.Support.COMMON_EVENT_BOOT_COMPLETED) {
          this.initViewModel();
        }
      });
  }

  unregisterCommonEventChange(): void {
    log.showInfo('unregister common event change');
    if (this.mSubscriber) {
      commonEventManager.unsubscribe(this.mSubscriber);
      this.mSubscriber = null;
    }
  }

  /**
   * 注册二级界面监听器
   */
  registerListeners(): void {
    InputMethodModel.registerListener(this);
  }

  /**
   * 注销二级界面监听器
   */
  unregisterListeners(): void {
    InputMethodModel.unregisterListener(this);
  }

  /**
   * 获取输入法项图标并更新
   *
   * @param inputMethodItem 输入法二级界面项
   * @param callback 回调函数，用于更新界面图标
   */
  updateIcon(inputMethodItem: InputMethodItemType, callback: Callback<image.PixelMap>): void {
    log.showInfo(`[updateIcon] icon inputMethodItem:${JSON.stringify(inputMethodItem)}`);
    if (inputMethodItem.vType === 'InputMethodInfo') {
      this.updateMethodPropertyIcon(inputMethodItem as InputMethodInfo, callback);
    } else {
      this.updateInputMethodSubtypeIcon(inputMethodItem as InputMethodSubtypeInfo, callback);
    }
  }

  /**
   * 获取输入法项名称并更新
   *
   * @param inputMethodItem 输入法二级界面项
   * @param callback 回调函数用于更新名称
   */
  updateTitle(inputMethodItem: InputMethodItemType, callback: Callback<string>): void {
    log.showInfo(`[updateTitle] icon inputMethodItem:${JSON.stringify(inputMethodItem)}`);
    if (inputMethodItem.vType === 'InputMethodInfo') {
      this.updateMethodPropertyTitle(inputMethodItem as InputMethodInfo, callback);
    } else {
      this.updateInputMethodSubtypeTitle(inputMethodItem as InputMethodSubtypeInfo, callback);
    }
  }

  updateInputMethodSubtypeTitle(inputMethodSubtype: InputMethodSubtypeInfo, callback: Callback<string>): void {
    if (inputMethodSubtype.subtype.label === undefined) {
      log.showInfo(`[updateInputMethodSubtypeTitle] label undefined. ${JSON.stringify(inputMethodSubtype)}`);
      return;
    }
    callback(inputMethodSubtype?.subtype?.label);
  }

  /**
   * 监听到输入法变化后，更新输入法列表及子类型
   */
  updateInputMethodInfo(inputMethodProperty: inputMethod.InputMethodProperty,
    inputMethodSubtype: InputMethodSubtype): void {
    let currInputMethod: InputMethodInfo = AppStorage.get('currentInputMethod') as InputMethodInfo;
    let currSubtype: InputMethodSubtypeInfo = AppStorage.get('currentInputMethodSubtype') as InputMethodSubtypeInfo;
    log.showInfo(`updateInputMethodInfo current InputMethod:${JSON.stringify(currInputMethod)}, subtype:${JSON.stringify(currSubtype)}`);
    let targetInputMethodInfo: InputMethodInfo = {
      vType: 'InputMethodInfo',
      property: inputMethodProperty
    } as InputMethodInfo;
    if (!this.isInputMethodPropertyInfoEqual(targetInputMethodInfo, currInputMethod)) {
      log.showInfo('updateInputMethodInfo MethodChange');
      AppStorage.setOrCreate('currentInputMethod', targetInputMethodInfo);
      let event = InputMethodEvent.createMethodChangeEvent(inputMethodProperty);
      EvtBus.post(InputMethodEvent, event);
      /**
       * when switch inputMethod, framework will first update config.
       * We can get correct subtype in <initLanguageList()>.
       */
      this.refreshCurrentInputMethodTitle(inputMethodProperty);
    }
    this.initLanguageList();

    this.fullLanguageList.forEach((item: InputMethodSubtype) => {
      if (item.id === inputMethodSubtype.id) {
        inputMethodSubtype = item;
      }
    });

    let targetSubtypeInfo: InputMethodSubtypeInfo = {
      vType: 'InputMethodSubtypeInfo',
      subtype: inputMethodSubtype
    } as InputMethodSubtypeInfo;
    // Before switching the status bar icon, compare the language and mode.
    if (!this.isInputMethodSubtypeEqual(inputMethodSubtype, currSubtype)) {
      log.showInfo('updateInputMethodInfo LanguageChange');
      AppStorage.setOrCreate('currentInputMethodSubtype', targetSubtypeInfo);
      sSettingsUtil.setValue(inputMethodSubtype.locale + 'LAST_CHOOSE', inputMethodSubtype.mode);
      let event = InputMethodEvent.createLanguageChangeEvent(inputMethodSubtype);
      EvtBus.post(InputMethodEvent, event);
    }
  }

  /**
   * 切换输入法
   *
   * @param inputMethodItem 切换目标输入法或子类型
   */
  switchInputMethod(inputMethodItem?: InputMethodItemType): void {
    log.showInfo(`[switchInputMethod] inputMethodItem: ${JSON.stringify(inputMethodItem)}`);
    if (inputMethodItem?.vType === 'InputMethodInfo') {
      this.switchCurrentInputMethod(inputMethodItem as InputMethodInfo);
    } else {
      this.switchCurrentSubtype(inputMethodItem as InputMethodSubtypeInfo);
    }
  }

  registerUpdatePanelWindowListener(listener: InputMethodItemChangeListener): void {
    let res = this.mUpdatePanelWindowListeners.add(listener);
    log.showInfo(`register mUpdatePanelWindowListeners res: ${res}, size: ${this.mUpdatePanelWindowListeners.size}`);
  }

  unregisterUpdatePanelWindowListener(listener: InputMethodItemChangeListener): void {
    let res = this.mUpdatePanelWindowListeners.delete(listener);
    log.showInfo(`unregister mUpdatePanelWindowListeners res: ${res}, size: ${this.mUpdatePanelWindowListeners.size}`);
  }

  registerStateChangeListener(listener: StateChangeListener): void {
    let res = this.mStateChangeListeners.add(listener);
    log.showInfo(`register StateChangeListener res: ${res}, size: ${this.mStateChangeListeners.size}`);
  }

  unregisterStateChangeListener(listener: StateChangeListener): void {
    let res = this.mStateChangeListeners.delete(listener);
    log.showInfo(`unregister StateChangeListener res: ${res}, size: ${this.mStateChangeListeners.size}`);
  }

  isInputMethodItemTypeEqual(leftInputMethod: InputMethodItemType, rightInputMethod: InputMethodItemType): boolean {
    if (leftInputMethod == null || rightInputMethod == null) {
      if (leftInputMethod == null && rightInputMethod == null) {
        log.showInfo(`leftInputMethod and rightInputMethod is null`);
        return true;
      }
      log.showInfo(`compare with null! leftInputMethod:${JSON.stringify(leftInputMethod)}, rightInputMethod:${JSON.stringify(rightInputMethod)}`);
      return false;
    }

    if (leftInputMethod.vType === 'InputMethodInfo' && rightInputMethod.vType === 'InputMethodInfo') {
      return this.isInputMethodPropertyInfoEqual(leftInputMethod as InputMethodInfo,
        rightInputMethod as InputMethodInfo);
    } else if (leftInputMethod.vType === 'InputMethodSubtypeInfo' &&
      rightInputMethod.vType === 'InputMethodSubtypeInfo') {
      return this.isInputMethodSubtypeInfoEqual(leftInputMethod as InputMethodSubtypeInfo,
        rightInputMethod as InputMethodSubtypeInfo);
    } else {
      return false;
    }
  }

  isInputMethodPropertyInfoEqual(leftProperty: InputMethodInfo, rightProperty: InputMethodInfo): boolean {
    let propertyLeft = leftProperty?.property;
    let propertyRight = rightProperty?.property;
    if (CheckEmptyUtils.isEmpty(propertyLeft) && CheckEmptyUtils.isEmpty(propertyRight)) {
      log.showInfo(`leftProperty and rightProperty all empty`);
      return true;
    }
    if (CheckEmptyUtils.isEmpty(propertyLeft) || CheckEmptyUtils.isEmpty(propertyRight)) {
      log.showInfo(`leftProperty or rightProperty is empty`);
      return false;
    }
    /**
     * arkts does not support the keyof operator.
     * The keys is based on the attribute of inputMethod framework
     * InputMethodProperty (packageName and methodId are deprecated).
     */
    let keys: string[] = ['name', 'id', 'label', 'labelId', 'icon', 'iconId', 'extra'];
    for (let index = 0; index < keys.length; index++) {
      let key = keys[index];
      if (propertyLeft[key] !== propertyRight[key]) {
        log.showInfo(`property not equal, key:${key}, left property:${propertyLeft[key]}, right property:${propertyRight[key]}}`);
        return false;
      }
    }
    log.showInfo(`property equal, property:${JSON.stringify(propertyLeft)}`);
    return true;
  }

  isInputMethodSubtypeInfoEqual(leftSubtype: InputMethodSubtypeInfo, rightSubtype: InputMethodSubtypeInfo): boolean {
    if (CheckEmptyUtils.isEmpty(leftSubtype)) {
      log.showInfo(`leftSubtype is empty`);
      if (CheckEmptyUtils.isEmpty(rightSubtype)) {
        log.showInfo(`rightSubtype and rightProperty all empty`);
        return true;
      }
      return false;
    }
    let languageCompare: LanguageCompare;
    // 对于英文输入法，也需要比较模式（大小写）
    languageCompare = this.languageCompareUtils.getNormalCompare();
    return languageCompare.isInputMethodSubtypeInfoEqual(leftSubtype.subtype, rightSubtype.subtype);
  }

  isInputMethodSubtypeLabelEqual(leftSubtype: InputMethodSubtypeInfo, rightSubtype: InputMethodSubtypeInfo): boolean {
    if (CheckEmptyUtils.isEmpty(leftSubtype)) {
      log.showInfo(`leftSubtype is empty`);
      if (CheckEmptyUtils.isEmpty(rightSubtype)) {
        log.showInfo(`rightSubtype and rightProperty all empty`);
        return true;
      }
      return false;
    }
    let keys: string[] = ['name', 'id', 'label', 'labelId', 'icon', 'iconId', 'extra'];
    for (let index = 0; index < keys.length; index++) {
      let key = keys[index];
      if (leftSubtype.subtype[key] !== rightSubtype.subtype[key]) {
        log.showInfo(`property not equal, key:${key}, left property:${leftSubtype.subtype[key]}, right property:${rightSubtype.subtype[key]}`);
        return false;
      }
    }
    log.showInfo(`property equal, property:${JSON.stringify(leftSubtype)}`);
    return true;
  }

  isInputMethodSubtypeEqual(leftSubtype?: InputMethodSubtype, rightSubtype?: InputMethodSubtypeInfo): boolean {
    log.showInfo(`left:${JSON.stringify(leftSubtype)}, right:${JSON.stringify(rightSubtype)}`);
    if (leftSubtype === undefined || rightSubtype === undefined) {
      return false;
    }
    if (leftSubtype.language === rightSubtype.subtype.language && leftSubtype.mode === rightSubtype.subtype.mode &&
      leftSubtype.label === rightSubtype.subtype.label && leftSubtype.icon === rightSubtype.subtype.icon) {
      log.showInfo('[isInputMethodSubtypeEqual] left = right');
      return true;
    }
    log.showInfo('[isInputMethodSubtypeEqual] left != right');
    return false;
  }

  /**
   * 二级界面窗口状态
   *
   * @param panelState if true, panel show
   */
  updateState(panelState: boolean): void {
    log.showInfo(`updateState, panelState: ${panelState}`);
    if (!panelState) {
      // 清除hover选中态
      this.mStateChangeListeners.forEach((listener): void => listener.onStateChange());
      return;
    }

    // 二级界面打开时，更新输入法列表。
    this.initInputMethodList();
    this.initLanguageList();
  }

  /**
   * 刷新二级界面窗口大小
   */
  updateInputMethodPanelWindow(): void {
    this.mUpdatePanelWindowListeners.forEach((listener): void => listener.updateInputMethodPanelWindow());
  }

  reportSwitchEvent(switchType: number): void {
    // 等待切换完成
    setTimeout(async () => {
      let currentImeSubType = inputMethod.getCurrentInputMethodSubtype();
      if (currentImeSubType?.id === undefined) {
        log.showError(`getInputMethodImage failed, inputMethodInfo:${JSON.stringify(currentImeSubType)}`);
        return;
      }
      let data = await ResUtils.getBundleInfo(TAG, currentImeSubType?.name);
      log.showInfo(`data: ${JSON.stringify(data)}`);
      let resource: ResourceManager.Resource = {
        bundleName: data.name,
        moduleName: data.entryModuleName,
        id: Number(data?.appInfo?.labelId)
      };
      let label = ResUtils.getOutString(resource);
      let reportType: number;
      if (switchType === SwitchType.SWITCH_INPUT_METHOD) {
        reportType = ReportType.REPORT_SWITCH_INPUT_METHOD;
      } else {
        reportType = ReportType.REPORT_SWITCH_LANGUAGE;
      }
      HiSysEventUtil.reportInputMethod(reportType, label, currentImeSubType?.label || '');
    }, 50);
  }

  private isNeedInitList(remoteData: inputMethod.InputMethodProperty[] | InputMethodSubtype[], type: string): boolean {
    let localList = (type === 'InputMethodInfo') ? this.mInputMethodList : this.mLanguageList;
    if (localList.length === 0 || remoteData.length !== localList.length) {
      return true;
    }

    for (let remoteIdx = 0; remoteIdx < remoteData.length; remoteIdx++) {
      let data = remoteData[remoteIdx];
      // flag 为true，代表list中存在data
      const flag: boolean = localList.some((listItem: InputMethodInfo | InputMethodSubtypeInfo): boolean => {
        if (type === 'InputMethodInfo') {
          let propertyInfo: InputMethodInfo = {
            vType: type,
            property: data as inputMethod.InputMethodProperty
          };
          return this.isInputMethodPropertyInfoEqual(propertyInfo, listItem as InputMethodInfo);
        } else if (type === 'InputMethodSubtypeInfo') {
          let subtypeInfo: InputMethodSubtypeInfo = {
            vType: type,
            subtype: data as InputMethodSubtype
          };
          return this.isInputMethodSubtypeLabelEqual(subtypeInfo, listItem as InputMethodSubtypeInfo);
        }
        return false;
      });
      if (!flag) {
        // 没找到，需要重新初始化该list
        log.showInfo(`isNeedInitList true`);
        return true;
      }
    }
    return false;
  }

  /**
   * 初始化输入法列表
   */
  private async initInputMethodList(): Promise<void> {
    log.showInfo(`initInputMethodList len:${this.mInputMethodList.length}`);
    let mInputSetting = await this.mInputSetting;
    mInputSetting?.getInputMethods(false).then((data: Array<inputMethod.InputMethodProperty>) => {
      log.showInfo(`[initInputMethodList] Succeeded in getting inputMethods. method list:${data}`);
      if (data === undefined || data.length === 0) {
        log.showInfo('get no input method.');
        return;
      }

      if (!this.isNeedInitList(data, 'InputMethodInfo')) {
        log.showInfo(`[initInputMethodList] no need to init mInputMethodList`);
        return;
      }

      this.mInputMethodList = [];
      AppStorage.setOrCreate('inputMethodList', this.mInputMethodList);

      data?.forEach((item: inputMethod.InputMethodProperty) => {
        this.addInputMethodItem(item);
      });

      log.showInfo(`after add mInputMethodList item. mInputMethodList len:${this.mInputMethodList.length}`);
      AppStorage.setOrCreate('inputMethodList', this.mInputMethodList);

      // 刷新当前输入法
      this.getCurrentInputMethod(true);

      // 更新输入法列表后，刷新二级界面窗口
      this.updateInputMethodPanelWindow();
    }).catch((err: BusinessError) => {
      log.showError('Failed to getInputMethods: ' + JSON.stringify(err));
    });
  }

  /**
   * 获取当前输入法
   */
  private async getCurrentInputMethod(needRefreshCurrentInputMethod: boolean): Promise<void> {
    try {
      let currentIme: inputMethod.InputMethodProperty | null = await InputMethodUtils.queryCurrentInputMethod();
      log.showInfo('true Succeeded in getting inputMethods.');
      if (!currentIme) {
        log.showError('get getInputMethods fail');
        return;
      }
      this.setCurrentInputMethod(currentIme, needRefreshCurrentInputMethod);
    } catch (err) {
      log.showError('Failed to getInputMethods: ' + JSON.stringify(err));
    }
  }

  private addInputMethodItem(inputMethodInfo: inputMethod.InputMethodProperty): void {
    log.showInfo(`add input method item, inputMethodInfo: ${JSON.stringify(inputMethodInfo)}}`);
    // 去重
    let inputMethodList = this.mInputMethodList.filter((item) => item.property?.id === inputMethodInfo.id);
    if (inputMethodList.length > 0) {
      return;
    }
    let info = {} as InputMethodInfo;
    info.vType = 'InputMethodInfo';
    info.property = inputMethodInfo;
    this.mInputMethodList.push(info);
  }

  /**
   * 初始化输入法子类型列表
   */
  private async initLanguageList(): Promise<void> {
    log.showInfo(`initLanguageList len:${this.mLanguageList.length}`);
    try {
      let mInputSetting = await this.mInputSetting;
      let subTypeList = await mInputSetting?.listCurrentInputMethodSubtype();
      log.showInfo(`Succeeded in listing inputMethodSubtype. data len:${subTypeList?.length}`);
      if (subTypeList === undefined || subTypeList.length === 0) {
        log.showInfo('[initLanguageList] listCurrentInputMethodSubtype get no method.');
        return;
      }
      let subType = subTypeList[0];
      this.dealInputMethod(subTypeList);
    } catch (err) {
      log.showError('Failed to listInputMethodSubtype code:' + err?.code + ', message:' + err?.message);
    }
  }

  private async dealInputMethod(subTypeList: Array<InputMethodSubtype>): Promise<void> {
    log.showInfo(`dealInputMethod subTypeList:${JSON.stringify(subTypeList)}`);
    this.fullLanguageList = subTypeList;
    if (!this.isNeedInitList(subTypeList, 'InputMethodSubtypeInfo')) {
      log.showInfo(`[initLanguageList] no need to init languageList`);
      await this.initCurrentInputMethodSubtype();
      return;
    }

    this.mLanguageList = [];
    subTypeList?.forEach((item) => {
      this.addLanguageItem(item, this.mLanguageList);
    });
    log.showInfo(`after add language item. languageList len:${this.mLanguageList.length}`);
    AppStorage.setOrCreate('languageList', this.mLanguageList);
    log.showInfo(`languageList len: ${this.mLanguageList.length}`);

    // 刷新当前输入法子类型
    await this.initCurrentInputMethodSubtype();

    // 更新输入法列表后，刷新二级界面窗口
    this.updateInputMethodPanelWindow();
  }

  private addLanguageItem(inputMethodInfo: InputMethodSubtype, mLanguageList: InputMethodSubtypeInfo[]): void {
    log.showInfo(`add language item, inputMethodInfo: ${JSON.stringify(inputMethodInfo)}}`);
    // // 英文时默认显示小写//导致无法切换大小写输入法
    // if (inputMethodInfo.language === 'english' && inputMethodInfo.mode === 'upper') {
    //   return;
    // }
    // 去重 —— Only labels are different for different system languages
    let languageList = this.mLanguageList.filter((item) => item.subtype.label === inputMethodInfo.label);
    if (languageList.length > 0) {
      return;
    }
    let info = {} as InputMethodSubtypeInfo;
    info.vType = 'InputMethodSubtypeInfo';
    info.subtype = inputMethodInfo;
    // Only one input method exists
    let subTypeIdx = this.mLanguageList.findIndex(item => inputMethodInfo.id === item.subtype.id);
    if (subTypeIdx !== -1) {
      mLanguageList.splice(subTypeIdx, 1, info);
    } else {
      mLanguageList.push(info);
    }
  }

  private dealLowerLanguage(language: string, item: InputMethodSubtypeInfo,
    callback: Callback<InputMethodSubtypeInfo>): void {
    if (item.subtype.language === language && item.subtype.mode === 'lower') {
      log.showInfo(`[updateSubtypeIcon] data:${JSON.stringify(item)}`);
      callback(item);
    }
  }


  private async initCurrentInputMethodSubtype(): Promise<void> {
    let currentImeSubType: InputMethodSubtype | null = await InputMethodUtils.queryCurrentInputMethodSubtype();
    if (!currentImeSubType) {
      log.showError('[initCurrentInputMethodSubtype] error');
      return;
    }
    let subtype = {} as InputMethodSubtypeInfo;
    subtype.vType = 'InputMethodSubtypeInfo';
    subtype.subtype = currentImeSubType;
    log.showInfo(`[initCurrentInputMethodSubtype] currentImeSubType:${JSON.stringify(currentImeSubType)}`);
    if (this.isInputMethodSubtypeEqual(currentImeSubType, this.mCurrentSubtype)) {
      log.showInfo(`no need to update current inputmethod subtype, subtype:${JSON.stringify(currentImeSubType)}`);
      return;
    }
    this.fullLanguageList.forEach((item: InputMethodSubtype) => {
      if (item.id === subtype.subtype?.id) {
        subtype.subtype = item;
      }
    });
    AppStorage.setOrCreate('currentInputMethodSubtype', subtype);
    this.mCurrentSubtype = subtype;
    let event = InputMethodEvent.createLanguageChangeEvent(subtype.subtype);
    EvtBus.post(InputMethodEvent, event);
  }

  private switchCurrentInputMethod(propertyInfo?: InputMethodInfo): void {
    log.showInfo(`switch to ${propertyInfo?.property?.packageName}`);
    try {
      InputMethodUtils.switchInputMethod(propertyInfo?.property, (err, result) => {
        if (err !== undefined) {
          log.showError(`Failed to switch inputMethod: ${JSON.stringify(err)}`);
          return;
        }
        if (result) {
          log.showInfo('Succeeded in switching inputMethod.');
          this.getCurrentInputMethod(false);
          windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_INPUT_PANEL);
        } else {
          log.showError('Failed to switch inputMethod');
        }
      });
    } catch (error) {
      log.showError('[switchCurrentInputMethod] error' + JSON.stringify(error));
    }
  }

  private switchCurrentSubtype(subtypeInfo?: InputMethodSubtypeInfo): void {
    log.showInfo(`switch to ${subtypeInfo?.subtype?.language}`);
    try {
      InputMethodUtils.switchCurrentInputMethodSubtype(subtypeInfo?.subtype, async (err, result) => {
        if (err !== undefined) {
          log.showError(`Failed to switchCurrentInputMethodSubtype: ${JSON.stringify(err)}`);
          return;
        }
        if (result) {
          log.showInfo('Succeeded in switching currentInputMethodSubtype.');
          // 更新当前输入法子类型状态
          await this.initCurrentInputMethodSubtype();
          windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_INPUT_PANEL);
        } else {
          log.showError('Failed to switchCurrentInputMethodSubtype');
        }
      });
    } catch (error) {
      log.showError('[switchCurrentSubtype] error' + JSON.stringify(error));
    }
  }
}

let inputMethodPanelViewModel = new InputMethodPanelViewModel();

export default inputMethodPanelViewModel as InputMethodPanelViewModel;