/*
 *
 *  Copyright (c) 2025 Huawei Device Co., Ltd.
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

import { abilityAccessCtrl, bundleManager } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { curves } from '@kit.ArkUI';
import hiboardIPCService from '../idlService/HiboardRemoteService';
import { CommonUtil } from '../util/CommonUtil';
import { feedbackLogger as log } from '../util/FeedBackLogUtil';
import { AgentServiceAssistantView } from '../pages/base/AgentServiceAssistantView';
import { AgentServiceAssistantData, IAgentCardFunctionElement, FunctionType } from '../common/bean/AgentServiceInfo';
import { HaModule } from '../common/constants/HaReportConstants';
import { PreferenceStore } from '../dao/PreferenceStore';
import { CloudConfigDao } from '../dao/CloudConfigDao';
import { CommonContants } from '../common/constants/CommonContants';
import { JumpInfo } from '../common/bean/IIntelligentCommonData';
import JumpController from './JumpController';
import RemoteCallbackManager from '../idlService/RemoteCallbackManager';
import { Module, ModuleParams } from '../idlService/IpcCommon';
import IntelligentCompatibilityChecker from './IntelligentCompatibilityChecker';

const TAG: string = 'AgentServiceAssistantController';

// 开关开启标识。
const SWITCH_OPEN_TAG: string = 'true';
// 跳转信息标识。
const JUMP_INFO_LIST_TAG: string = 'jumpInfoList';
// 智能体服务助手 FormItemID
const FORM_ITEM_ID = 'agentCard';
// 引导语轮播间隔
const GUIDES_SWIPE_TIME_INTERVAL: number = 3000; // 3s

// 智能体查询数据标识。
export const AGENT_QUERY_INFO_TAG: string = 'agentQueryInfo';

/**
 * 智能体服务助手开关标识。
 */
export const enum AgentServiceAssistantSwitch {
  // 智能体服务助手总开关标识。
  GENERAL_SWITCH = 'serviceAssistantSwitchStatus',
  // 智能体服务助手云控开关标识。
  CLOUD_SWITCH = 'isEnableAgentServiceAssistant',
}

/**
 * 智能体服务助手版本标识。
 */
const enum AgentServiceAssistantVersion {
  /**
   * 修改点：
   * 1. 初始版本，添加了智能体服务助手的基本代码。
   */
  VERSION_ZERO = 0,
}

/**
 * 智能体服务助手公共事件请求参数标识。
 */
const enum AgentServiceAssistantRequestParam {
  // 能力支持标识
  IS_SERVICE_ASSISTANT_SUPPORTED = 'isServiceAssistantSupported',
  // 版本标识
  VERSION = 'version',
}

/**
 * 智能体服务助手公共事件消息命令。
 */
const enum AgentServiceAssistantCommend {
  REFRESH = 'refresh',
  CLEAR = 'clear',
}

/**
 * 智能体服务助手Controller类，用于控制数据刷新和处理业务逻辑。
 */
export class AgentServiceAssistantController {
  private static instance: AgentServiceAssistantController;
  private view?: AgentServiceAssistantView;
  private isHomeOnFocus: boolean = false;

  private isSwitchOn: boolean = true;
  private isCloudSwitchOn: boolean = false;

  private currentGuideExposeTime: number = 0;
  private guidesTimeoutId: number | undefined = undefined;
  private guidesSwipeInterval: number = GUIDES_SWIPE_TIME_INTERVAL;

  /**
   * 私有构造函数，单例模式。
   */
  private constructor() {
  }

  /**
   * 获取单例。
   *
   * @returns 单例。
   */
  public static getInstance(): AgentServiceAssistantController {
    if (!AgentServiceAssistantController.instance) {
      AgentServiceAssistantController.instance = new AgentServiceAssistantController();
      // 注册通信回调
      RemoteCallbackManager.registerCallback(Module.AGENT_SERVICE_ASSISTANT,
        (command: string, result: Record<string, string | object>, data: rpc.MessageSequence, code: number):
          Promise<void> => AgentServiceAssistantController.instance.onRemoteMessage(command, result));
    }
    return AgentServiceAssistantController.instance;
  }

  /**
   * 智能体服务助手组件AboutToAppear事件处理回调。
   *
   * @param view 智能体服务助手组件。
   */
  public async onViewAboutToAppear(view: AgentServiceAssistantView): Promise<void> {
    this.view = view;
    await this.switchInit();
  }

  /**
   * 检查当前是否使能智能体服务助手。
   *
   * @returns true，使能；false，不使能。
   */
  private isEnabled() {
    if (!IntelligentCompatibilityChecker.isSupportServiceAssistant()) {
      log.showWarn(TAG, `isEnabled, intelligent does not support yet`);
      return false;
    }
    if (!this.isCloudSwitchOn) {
      log.showWarn(TAG, `isEnabled, cloud switch is off`);
      return false;
    }
    if (!this.isSwitchOn) {
      log.showWarn(TAG, `isEnabled, switch is off`);
      return false;
    }
    return true;
  }

  /**
   * 开关初始化。
   * 包含用户设置开关和运营云控开关。
   */
  private async switchInit() {
    try {
      this.isSwitchOn =
        (await PreferenceStore.getInstance()
          .get(CommonContants.SERVICE_ASSISTANT_SWITCH, true, HaModule.SETTING) as boolean) ?? true;
      this.isCloudSwitchOn =
        (await CloudConfigDao.get4HCloudConfigByKey(AgentServiceAssistantSwitch.CLOUD_SWITCH) === SWITCH_OPEN_TAG);
      AppStorage.setOrCreate<boolean>(AgentServiceAssistantSwitch.GENERAL_SWITCH, this.isEnabled());

      IntelligentCompatibilityChecker.registerVersionChangeCallBack(TAG, () => {
        this.updateCloudSwitch();
      });

      log.showInfo(TAG, `switchInit, isSwitchOn: ${this.isSwitchOn}, isCloudSwitchOn: ${this.isCloudSwitchOn}`);
    } catch (e) {
      log.showError(TAG, `switchInit failed, code: ${e?.code}, message: ${e?.message}`);
      return;
    }
  }

  /**
   * 获取智能体服务助手公共事件请求参数。
   *
   * @returns 公共事件请求参数。
   */
  public getRequestModuleParams(): ModuleParams {
    let moduleParams = new ModuleParams();
    moduleParams.module = Module.AGENT_SERVICE_ASSISTANT;
    moduleParams.params = {} as Record<string, string | number | boolean | string[]>;

    moduleParams.params[AgentServiceAssistantRequestParam.IS_SERVICE_ASSISTANT_SUPPORTED] = true;
    moduleParams.params[AgentServiceAssistantRequestParam.VERSION] = AgentServiceAssistantVersion.VERSION_ZERO;

    return moduleParams;
  }

  /**
   * 负一屏消息处理回调。
   *
   * @param result 消息数据。
   */
  public async onRemoteMessage(command: string, result: Record<string, string | object>): Promise<void> {
    if (!this.view) {
      log.showError(TAG, `onRemoteMessage, thie view is empty`);
      return;
    }

    if (!command) {
      log.showError(TAG, `commend is empty`);
      return;
    }

    switch (command) {
      case AgentServiceAssistantCommend.REFRESH:
        let dataStr: string = result.assistantDataStr as string;
        this.refreshAssistantData(dataStr);
        return;
      case AgentServiceAssistantCommend.CLEAR:
        this.clearAssistantData();
        return;
      default:
        log.showError(TAG, `onRemoteMessage, invalide commend ${command}`);
        return;
    }
  }

  /**
   * 更新智能体服务助手云控开关。
   */
  public async updateCloudSwitch() {
    this.isCloudSwitchOn =
      (await CloudConfigDao.get4HCloudConfigByKey(AgentServiceAssistantSwitch.CLOUD_SWITCH) === SWITCH_OPEN_TAG);
    log.showInfo(TAG, `updateCloudSwitch, cloud switch: ${this.isCloudSwitchOn}`);
    AppStorage.setOrCreate<boolean>(AgentServiceAssistantSwitch.GENERAL_SWITCH, this.isEnabled());
  }

  /**
   * 更新智能体服务助手常驻卡开关。
   */
  public updateSwitch(isOn: string | undefined): void {
    this.isSwitchOn = isOn === SWITCH_OPEN_TAG;
    log.showInfo(TAG, `updateSwitch, isOn: ${this.isSwitchOn}`);
    if (this.view && !this.isSwitchOn) {
      this.view.isMenuOpen = false;
    }
    animateTo({
      delay: 300,
      curve: curves.springMotion(0.416, 1)
    }, () => {
      AppStorage.setOrCreate<boolean>(AgentServiceAssistantSwitch.GENERAL_SWITCH, this.isEnabled());
    });
    PreferenceStore.getInstance().put(CommonContants.SERVICE_ASSISTANT_SWITCH, this.isSwitchOn, HaModule.SETTING);
  }

  /**
   * 设置焦点状态.
   *
   * @param status 首页是否展示
   * */
  public setFocus(status: boolean) {
    if (!this.view) {
      log.showWarn(TAG, 'setFocus view is not ready');
      return;
    }
    this.isHomeOnFocus = status;
    this.homeFocusChange();
  }

  /**
   * 引导语变化处理回调。
   */
  private queryGuideChange() {
    log.showInfo(TAG, `queryGuideChange start`);
    if (!this.view || !this.isEnabled()) {
      log.showWarn(TAG, `queryGuideChange, the view: ${!!this.view}, isEnabled: ${this.isEnabled()}`);
      this.clearGuidesSwipe();
      return;
    }
    if (this.guidesTimeoutId !== undefined) {
      this.clearGuidesSwipe();
    }
    if (!this.isHomeOnFocus) {
      log.showError(TAG, 'queryGuideChange, intelligent is not on focus');
      // 数据请求回来，但是负一屏已被划出的场景,下一次划入重置轮播
      this.view.exposeGuideIndex = 0;
      this.currentGuideExposeTime = 0;
      return;
    }
    this.swipeGuides2Idx(0);
  }

  /**
   * 主页聚焦状态变化处理回调。
   */
  private homeFocusChange() {
    if (!this.view || !this.isEnabled()) {
      log.showWarn(TAG, `homeFocusChange, the view: ${!!this.view}, isEnabled: ${this.isEnabled()}`);
      this.clearGuidesSwipe();
      return;
    }
    // 离开负一屏时，若存在轮播任务，则取消轮播。
    if (!this.isHomeOnFocus && this.guidesTimeoutId !== undefined) {
      this.clearGuidesSwipe();
      return;
    }
    // 进入负一屏，若不存在引导语，直接返回。
    if (!this.view.asaCard?.guides) {
      log.showInfo(TAG, 'homeFocusChange, did not get guides yet');
      return;
    }
    // 如果当前没有开始轮播引导语，则从第一个开始。
    if (!this.currentGuideExposeTime) {
      this.swipeGuides2Idx(0);
      return;
    }
    // 若当前轮播引导语展示时间已到，则切换到下一个。
    if ((Date.now() - this.currentGuideExposeTime) > this.guidesSwipeInterval) {
      this.swipeGuides2Idx(this.view.exposeGuideIndex + 1);
    } else {
      this.swipeGuides2Idx(this.view.exposeGuideIndex);
    }
  }

  /**
   * 切换到目标下标的引导语。
   *
   * @param index 目标引导语的下标。
   */
  private swipeGuides2Idx(index: number): void {
    if (!this.view) {
      log.showWarn(TAG, `swipeGuides2Idx, the view is empty`);
      return;
    }
    // 若负一屏未聚焦，则直接返回。
    if (!this.isHomeOnFocus) {
      log.showInfo(TAG, 'swipeGuides2Idx, home is not on focus');
      return;
    }
    // 若无引导语，则直接返回
    if (!this.view.asaCard?.guides || this.view.asaCard?.guides?.length === 0) {
      log.showInfo(TAG, 'swipeGuides2Idx, guides is empty');
      return;
    }
    // 若index超出引导语数量，则从头开始。
    if (index >= this.view.asaCard.guides.length) {
      index = 0;
    }
    log.showInfo(TAG, `swipeGuides2Idx index: ${index}`);
    this.view.exposeGuide = this.view.asaCard.guides[index].name;
    this.view.exposeGuideIndex = index;

    // 若仅存在一条引导语，则创建轮播
    if (this.view.asaCard.guides.length === 1) {
      log.showInfo(TAG, `swipeGuides2Idx, only one guide, no need to swipe`);
      return;
    }
    this.currentGuideExposeTime = Date.now();
    this.guidesTimeoutId = setTimeout(() => {
      this.swipeGuides2Idx(index + 1);
    }, this.guidesSwipeInterval);
  }

  /**
   * 关闭引导语轮播。
   */
  private clearGuidesSwipe() {
    if (this.guidesTimeoutId) {
      log.showInfo(TAG, `clearGuidesSwipe, start`);
      clearTimeout(this.guidesTimeoutId);
      this.guidesTimeoutId = undefined;
    }
  }

  /**
   * 将给定的数据更新至智能体服务助手。
   *
   * @param dataStr 给定数据的JsonString。
   */
  public refreshAssistantData(dataStr: string) {
    try {
      if (!this.view) {
        log.showError(TAG, `refreshAssistantData, the view is empty`);
        return;
      }

      if (!dataStr) {
        log.showError(TAG, `refreshAssistantData, dataStr is empty.`);
        return;
      }

      let data: AgentServiceAssistantData = CommonUtil.securedJsonParse(dataStr) as AgentServiceAssistantData;
      let refreshTime: number = new Date().getTime();
      log.showInfo(TAG, `refreshAssistantData, data: ${!!dataStr}`);

      this.view.asaCard = data.asaCard;
      this.view.refreshTime = refreshTime;
      this.queryGuideChange();
      return;
    } catch (e) {
      log.showError(TAG, `refreshAssistantData failed, code: ${e?.code}, message: ${e?.message}`);
      return;
    }
  }

  /**
   * 清除智能体服务助手数据。
   */
  public clearAssistantData() {
    try {
      if (!this.view) {
        log.showError(TAG, `clearAssistantData, the view is empty`);
        return;
      }

      let refreshTime: number = new Date().getTime();
      log.showInfo(TAG, `clearAssistantData start`);

      this.view.asaCard = undefined;
      this.view.refreshTime = refreshTime;
    } catch (e) {
      log.showError(TAG, `clearAssistantData failed, code: ${e?.code}, message: ${e?.message}`);
      return;
    }
  }

  /**
   * 卡片点击处理函数。
   *
   * @param data 点击参数。
   */
  public onFuncElementClick(data: IAgentCardFunctionElement): void {
    if (!data) {
      log.showError(TAG, `data is empty.`);
      return;
    }

    try {
      const actionType: FunctionType = data.type;
      switch (actionType) {
        case FunctionType.CALL_AGENT:
          this.callAgent(data);
          break;
        case FunctionType.JUMP_TO_PAGE:
          this.jumpToPage(data);
          break;
        default:
          log.showError(TAG, `clickCard failed, invalid type: ${actionType}`);
      }
      return;
    } catch (e) {
      log.showError(TAG, `clickCard failed, code: ${e?.code}, message: ${e?.message}`);
      return;
    }
  }

  /**
   * 通知负一屏拉起智能体。
   *
   * @param data 通知数据。
   */
  private callAgent(data: IAgentCardFunctionElement): void {
    try {
      let token = bundleManager.getBundleInfoSync(CommonContants.INTELLIGENT_BUNDLENAME,
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION).appInfo.accessTokenId;
      let atManager = abilityAccessCtrl.createAtManager();
      let locationStatus = atManager.checkAccessTokenSync(token, 'ohos.permission.LOCATION');
      let approxLocationStatus = atManager.checkAccessTokenSync(token, 'ohos.permission.APPROXIMATELY_LOCATION');
      log.showInfo(TAG, `callAgent, locationStatus: ${locationStatus}, approxLocationStatus: ${approxLocationStatus}`);

      let dataStr: string = CommonUtil.securedStringify(data);

      if (locationStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED &&
        approxLocationStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        log.showInfo(TAG, `callAgent, launch agent`);
        hiboardIPCService.callAgent(dataStr);
      } else {
        log.showError(TAG, `callAgent, show permission`);
        AppStorage.setOrCreate<string>(AGENT_QUERY_INFO_TAG, dataStr);
        AppStorage.setOrCreate<boolean>(CommonContants.IS_SHOW_REQUEST_PERMISSION_PAGE, true);
      }
      return;
    } catch (e) {
      log.showError(TAG, `callAgent failed, code: ${e?.code}, message: ${e?.message}`);
      return;
    }
  }

  /**
   * 跳转页面。
   *
   * @param data 跳转数据。
   */
  private jumpToPage(data: IAgentCardFunctionElement): void {
    try {
      const params: Record<string, Object> = data.extras;
      const jumpInfoList: JumpInfo[] = params[JUMP_INFO_LIST_TAG] as JumpInfo[];
      if (!jumpInfoList) {
        log.showError(TAG, `jumpToPage failed, jumpInfoList is empty`);
        return;
      }
      JumpController.jumpAction(jumpInfoList, FORM_ITEM_ID);
      return;
    } catch (e) {
      log.showError(TAG, `jumpToPage failed, code: ${e?.code}, message: ${e?.message}`);
      return;
    }
  }

  /**
   * 解绑组件
   */
  public unbindView() {
    log.showInfo(TAG, 'unbindView start');
    this.view = undefined;
    this.clearGuidesSwipe();
  }

  /**
   * 清除内存。
   */
  public releaseMemory() {
    log.showInfo(TAG, 'releaseMemory');
    if (this.view) {
      this.view = undefined;
    }
    this.clearGuidesSwipe();
  }
}