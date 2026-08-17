/*
 * Copyright (c) 2026 Huawei Device Co., Ltd. All rights reserved.
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

import commonEventManager from '@ohos.commonEventManager';
import { CommonEventHelper } from '@ohos/scene.common/src/main/ets/commonevent/CommonEventHelper';
import { ConfigConstant } from '@ohos/scene.common/src/main/ets/constant/ConfigConstant';
import { EventBusNameConstant } from '@ohos/scene.common/src/main/ets/constant/EventBusNameConstant';
import { NO_SCENE, SCENE_DISABLE } from '@ohos/scene.common/src/main/ets/constant/ModeConstant';
import { SettingsDataKeyConstant } from '@ohos/scene.common/src/main/ets/constant/SettingsDataKeyConstant';
import { SystemParamUtil } from '@ohos/scene.common/src/main/ets/utils/SystemParamUtil';
import { EventBus } from '@ohos/scene.common/src/main/ets/framework/common/EventBus';
import { FactorType, EffectiveSourceType } from '@ohos/scene.common/src/main/ets/model/FactorModel';
import { LogUtil } from '@ohos/scene.common/src/main/ets/utils/LogUtil';
import { SettingsDataUtils } from '@ohos/scene.common/src/main/ets/utils/SettingsDataUtils';
import { BaseModeConfig } from '@ohos/scene.modeconfig/src/main/ets/adapter/BaseModeConfig';
import { AllowDisturbManager } from '@ohos/scene.configmanage/src/main/ets/manager/AllowDisturbManager';
import { LocalSceneManager } from '@ohos/scene.configmanage/src/main/ets/manager/LocalSceneManager';
import { El1ModeDataManager } from '@ohos/scene.datamanage/src/main/ets/manager/El1ModeDataManager';
import { ModeData } from '@ohos/scene.datamanage/src/main/ets/model/base/ModeModel';
import { ModeUtil } from '@ohos/scene.datamanage/src/main/ets/utils/ModeUtil';
import { ConfigType } from '@ohos/scene.datamanage/src/main/ets/model/base/ConfigType';
import { AllowDisturbDataManager } from '@ohos/scene.datamanage/src/main/ets/manager/AllowDisturbDataManager';
import { CurrentOpenedMode } from '@ohos/scene.datamanage/src/main/ets/model/base/ConfigModel';
import { CheckEmptyUtils } from '@ohos/scene.common/src/main/ets/utils/CheckEmptyUtils';
import { ModeConfigAdapter } from '@ohos/scene.modeconfig/src/main/ets/adapter/ModeConfigAdapter';
import { NOT_DISTURB_DISABLE, NOT_DISTURB_ENABLE } from '@ohos/scene.common/src/main/ets/constant/ModeConstant';
import { SettingLinkageManager } from '@ohos/scene.configlinkage/src/main/ets/manager/SettingLinkageManager';
import LiveViewManager from '@ohos/scene.configlinkage/src/main/ets/manager/LiveViewManager';
import { CLOSE, OPEN } from '../constant/StateConstants';
import { ActiveTimeHit, SceneTimeScheduleManager } from './SceneTimeScheduleManager';
import common from '@ohos.app.ability.common';

// 模式立即开启关闭的节流间隔时间
export const THROTTLE_INTERVAL_TIME: number = 300;

export const MIN_TIMESTAMP: number = 0;

const TAG: string = 'SceneStateManager: ';

/**
 * 模式状态管理模块
 */
export class StateManager {
  private static singleInstance: StateManager;
  // 当前开启模式，为0表示当前没有开启任何模式
  private currentScene: string = NO_SCENE;
  private scheduleSyncing: boolean = false;

  /**
   * 系统时间/时区改变：按本地定时条件立即重算启停（对齐设置深色模式）
   */
  private onTimeChangeEventHelper: CommonEventHelper = new CommonEventHelper({
    events: [
      commonEventManager.Support.COMMON_EVENT_TIME_CHANGED,
      commonEventManager.Support.COMMON_EVENT_TIMEZONE_CHANGED,
    ],
  }, (err, data) => {
    if (err?.code) {
      LogUtil.showError(TAG, `onTimeChangeEventHelper failed. code:${err?.code} message:${err?.message}`);
      return;
    }
    LogUtil.showInfo(TAG, 'onTimeChangeEventHelper sync by time schedule');
    void this.syncByTimeSchedule();
  });

  private onTimeConditionScheduleRefresh = (): void => {
    LogUtil.showInfo(TAG, 'TIME_CONDITION_SCHEDULE_REFRESH');
    void this.syncByTimeSchedule();
  };

  /**
   * 单例
   */
  public static getInstance(): StateManager {
    if (!StateManager.singleInstance) {
      StateManager.singleInstance = new StateManager();
    }
    return StateManager.singleInstance;
  }

  public init(): void {
    LogUtil.showInfo(TAG, 'init');
    this.onTimeChangeEventHelper.registerCommonEvent();
    EventBus.getInstance().on(EventBusNameConstant.TIME_CONDITION_SCHEDULE_REFRESH, this.onTimeConditionScheduleRefresh);
    if (!SystemParamUtil.isSupportIntelligentScene()) {
      LogUtil.showWarn(TAG, 'not support intelligent scene, no need registerSceneStatusListener');
      return;
    }
    // 进程启动时刷新一次本地定时器，覆盖重启后仍在时段内的场景
    void this.syncByTimeSchedule();
  }

  public deInit(): void {
    LogUtil.showInfo(TAG, 'deInit');
    this.onTimeChangeEventHelper.unRegisterCommonEvent();
    EventBus.getInstance().detach(EventBusNameConstant.TIME_CONDITION_SCHEDULE_REFRESH,
      this.onTimeConditionScheduleRefresh, false);
    if (!SystemParamUtil.isSupportIntelligentScene()) {
      LogUtil.showWarn(TAG, 'not support intelligent scene, no need unRegisterSceneStatusListener');
      return;
    }
  }

  /**
   * 按当前时间同步定时条件启停，并刷新 systemTimer（ECA 不可用时的本地兜底）。
   */
  public async syncByTimeSchedule(context?: common.Context): Promise<void> {
    if (this.scheduleSyncing) {
      LogUtil.showWarn(TAG, 'syncByTimeSchedule skipped: busy');
      return;
    }
    this.scheduleSyncing = true;
    try {
      const scheduler: SceneTimeScheduleManager = SceneTimeScheduleManager.getInstance();
      const hits: ActiveTimeHit[] = await scheduler.collectActiveHits();
      LogUtil.showInfo(TAG, `syncByTimeSchedule hits=${hits.length}`);
      const opened: CurrentOpenedMode | undefined = LocalSceneManager.getLocalSceneSync();
      const currentModeId: string = opened?.modeId ?? NO_SCENE;
      const openType: number = opened?.openType ?? FactorType.USER;

      if (hits.length > 0) {
        const keepCurrent: boolean = hits.some((h: ActiveTimeHit) => h.modeId === currentModeId);
        if (!keepCurrent) {
          const target: ActiveTimeHit = hits[0];
          LogUtil.showInfo(TAG, `syncByTimeSchedule startScene modeId:${target.modeId}`);
          this.startScene(target.modeId, FactorType.AUTO, EffectiveSourceType.AUTO_TIMER);
          if (!CheckEmptyUtils.checkStrIsEmpty(target.condition?.configId)) {
            this.saveEffectiveConfigId(target.condition.configId);
          }
        } else {
          // 已开启同一模式时仍刷新生效条件，便于二级页回显时段
          const currentHit: ActiveTimeHit | undefined =
            hits.find((h: ActiveTimeHit) => h.modeId === currentModeId) ?? hits[0];
          if (currentHit && !CheckEmptyUtils.checkStrIsEmpty(currentHit.condition?.configId)) {
            this.saveEffectiveConfigId(currentHit.condition.configId);
          }
        }
      } else if (currentModeId !== NO_SCENE && openType === FactorType.AUTO) {
        LogUtil.showInfo(TAG, `syncByTimeSchedule stopScene modeId:${currentModeId}`);
        this.stopScene(currentModeId, FactorType.AUTO, EffectiveSourceType.AUTO_TIMER);
      }
      await scheduler.refreshTimer(context);
    } catch (err) {
      LogUtil.showError(TAG, `syncByTimeSchedule fail: ${err?.code}, ${err?.message}`);
    } finally {
      this.scheduleSyncing = false;
    }
  }

  /**
   * 从settingsdata数据库获取当前开启模式
   *
   * @returns modeId
   */
  public getCurrentScene(): string {
    this.currentScene = ModeUtil.getModeOpenState().modeId;
    return this.currentScene;
  }

  /**
   * 开启模式
   *
   * @param modeId 待开启模式
   * @param operType 操作类型，值对应枚举类型FactorType
   * @param sourceType 开启模式的来源，可选参数，值对应枚举类型EffectiveSourceType
   * @param updateTime 更新时间， 可选参数
   * @returns 当前开启的模式id
   */
  public startScene(modeId: string, operType: number, sourceType?: number, updateTime?: number): string {
    LogUtil.showWarn(TAG, `startScene, scene: ${modeId}, operType: ${operType}`);
    this.effectiveScene(modeId, operType, sourceType, updateTime);
    if (operType === FactorType.USER) {
      this.saveEffectiveConfigId(ConfigConstant.RULE_NAME_SCENE_MANUAL_START, sourceType);
    }
    return this.getCurrentScene();
  }

  /**
   * 关闭模式
   *
   * @param modeId 待关闭模式
   * @param operType 操作类型，值对应枚举类型FactorType
   * @param sourceType 关闭模式来源，枚举类型EffectiveSourceType，可选参数
   * @param updateTime 更新时间，可选参数
   * @returns 当前模式
   */
  public stopScene(modeId: string, operType: number, sourceType?: number, updateTime?: number): string {
    LogUtil.showWarn(TAG, `stopScene, scene: ${modeId}, operType: ${operType}`);
    this.effectiveScene(NO_SCENE, operType, sourceType, updateTime);
    this.saveEffectiveConfigId(ConfigConstant.RULE_NAME_SCENE_DISABLED);
    return this.getCurrentScene();
  }

  /**
   * 保存生效中的规则id
   *
   * @param ruleName 规则名称
   */
  public saveEffectiveConfigByRule(ruleName: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(ruleName)) {
      LogUtil.showError(TAG, 'save effective config by rule fail, ruleName is invalid');
      return;
    }
    const prefixLen: number = ConfigConstant.RULE_NAME_PREFIX.length;
    if (ruleName.startsWith(ConfigConstant.RULE_NAME_PREFIX) && ruleName.length > prefixLen) {
      let configId: string = ruleName.substring(prefixLen);
      if (CheckEmptyUtils.checkStrIsEmpty(configId)) {
        LogUtil.showError(TAG, 'save effective config by rule fail, configId is invalid');
        return;
      }
      if (configId.indexOf('-')) {
        configId = configId.substring(0, configId.length - ConfigConstant.RULE_NAME_SUFFIX_LENGTH);
      }
      // 保存到数据库的条件(非临时创建规则，控制中心等)，从数据库取出configValue存到SettingsData
      LogUtil.showInfo(TAG, `saveEffectiveConfigByRule, configId: ${configId} ruleName: ${ruleName}`);
      this.saveEffectiveConfigId(configId);
    }
  }

  /**
   * 保存保存生效中的规则id/类型
   *
   * @param configId 配置id
   * @param sourceType 模式生效的来源，可选参数，值对应枚举类型EffectiveSourceType
   */
  public saveEffectiveConfigId(configId: string, sourceType?: number): void {
    SettingsDataUtils.setSecureValue(SettingsDataKeyConstant.INTELLIGENT_CONFIG_ID_IN_EFFECT, configId);
    const configType: ConfigType = ModeUtil.getTypeFromConfigId(configId);
    LogUtil.showInfo(TAG, `saveEffectiveConfigId. configId:${configId} configType:${configType}`);
  }

  /**
   * 获取已开启模式的触发的开启条件配置id
   *
   * @returns 条件开启返回configId ;手动开启返回manual_on, 关闭返回off
   */
  public getEffectiveConfigId(): string {
    return SettingsDataUtils.getSecureValue(SettingsDataKeyConstant.INTELLIGENT_CONFIG_ID_IN_EFFECT, '');
  }

  /**
   * 生效模式（该方法需要保证同步执行）
   *
   * @param nextScene 将要生效的模式
   * @param operType 操作类型，值对应枚举类型FactorType
   * @param sourceType 可选参数，模式变化的来源，枚举类型EffectiveSourceType
   * @param updateTime 可选参数，模式变化时间
   */
  private effectiveScene(nextScene: string, operType: number, sourceType?: number, updateTime?: number): void {
    this.getCurrentScene();
    LogUtil.showWarn(TAG, `effectiveScene, currentScene: ${this.currentScene}, nextScene: ${nextScene}, source: ${sourceType}`);
    // 待开启模式与当前模式相同，不做切换
    if (this.currentScene === nextScene) {
      let currentScene: CurrentOpenedMode | undefined = LocalSceneManager.getLocalSceneSync();
      LogUtil.showInfo(TAG, `effectiveScene, config's currentScene: ${currentScene?.modeId}`);
      if (currentScene && currentScene.modeId === this.currentScene) {
        return;
      }
    }
    if (!this.updateSettingsDataScene(nextScene, this.currentScene)) {
      LogUtil.showError(TAG, `updateSettingsDataScene fail, nextScene: ${nextScene}`);
      return;
    }
    this.notifyToUpdateScene(this.currentScene, nextScene, operType);
    const preScene: string = this.currentScene;
    this.currentScene = nextScene;
    this.updateConfigScene(preScene, nextScene, operType, sourceType, updateTime);
    this.updateIncomingConfig(nextScene);
    this.updateNotificationConfig(nextScene);
  }

  /**
   * 模式开启的时候，需要刷新一下通知勿扰和声音振动白名单数据
   *
   * @param scene 模式id
   */
  private updateNotificationConfig(scene: string): void {
    const modeConfig: BaseModeConfig = ModeConfigAdapter.getInstance().getConfigByModeId(scene);
    if (!modeConfig.isSupportNotDisturb) {
      LogUtil.showWarn(TAG, `scene ${scene} is not support notdisburt.`);
      return;
    }
    AllowDisturbDataManager.setAllowDisturbAppList(scene).then(()=> {
      this.updateSoundAndVibrationWhiteList(scene);
    });
  }

  /**
   * 持久化保存本地开启模式数据
   *
   * @param preScene 当前开启的模式信息
   * @param scene 即将开启的模式
   * @param operType 开启类型，值对应枚举类型FactorType
   * @param sourceType 开启模式的来源，可选参数，值对应枚举类型EffectiveSourceType
   * @param updateTime 更新时间，可选参数
   * @returns 更新成功返回1; 更新失败或未更新返回空
   */
  private updateConfigScene(preScene: string, scene: string, operType: number, sourceType?: number,
    updateTime?: number) {
    const openedMode: CurrentOpenedMode = {
      modeId: scene,
      openType: operType
    };
    LocalSceneManager.updateLocalScene(openedMode, preScene, sourceType, updateTime);
  }

  /**
   * 模式开启的时候，需要刷新一下声音振动白名单数据
   *
   * @param scene 模式id
   */
  private updateSoundAndVibrationWhiteList(scene: string) {
    if (scene !== SCENE_DISABLE) {
      AllowDisturbDataManager.setSoundAndVibrationWhiteList(scene);
    }
  }

  /**
   * 更新SettingsData数据库中模式，供外部监听
   * @param scene 目标模式
   * @param preScene 切换前模式，用于关闭时取消实况
   */
  private updateSettingsDataScene(scene: string, preScene: string = NO_SCENE): boolean {
    let isOpen: boolean = scene !== NO_SCENE;
    if (isOpen) {
      let modeData: ModeData | undefined = El1ModeDataManager.getInstance().queryModeDataByIdSync(scene);
      if (!modeData) {
        LogUtil.showError(TAG, `updateSettingsDataScene fail because no mode data, scene: ${scene}`);
        return false;
      }
      SettingsDataUtils.setSecureValue(SettingsDataKeyConstant.INTELLIGENT_SCENE_NAME, modeData?.modeName);
      SettingsDataUtils.setSecureValue(SettingsDataKeyConstant.INTELLIGENT_SCENE_ICON, modeData?.iconId);
      SettingsDataUtils.setSecureValue(SettingsDataKeyConstant.LAST_INTELLIGENT_SCENE_ID, scene);
    }
    // 先写实况载荷再写 focus_mode_*，供 SceneBoard 代发 Instant LOCAL_LIVE_VIEW
    this.updateLiveViewNotifyData(scene, preScene);
    // 保存当前开启模式
    const isSceneFault: boolean = SettingsDataUtils.setSecureValue(SettingsDataKeyConstant.FOCUS_MODE_PROFILE, scene);

    // 保存勿扰开关开启状态
    const isStartNotDisturb: boolean =
      isOpen && ModeConfigAdapter.getInstance().getConfigByModeId(scene).isSupportNotDisturb;
    let notDisturbStatus: string = isStartNotDisturb ? NOT_DISTURB_ENABLE : NOT_DISTURB_DISABLE;
    const isOpenFault: boolean =
      SettingsDataUtils.setSecureValue(SettingsDataKeyConstant.FOCUS_MODE_ENABLED, notDisturbStatus);
    const isOperateFault: boolean =
      SettingsDataUtils.setSecureValue(SettingsDataKeyConstant.OPERATE_SCENE_CHANGE, scene);
    if (!isSceneFault || !isOpenFault || !isOperateFault) {
      LogUtil.showError(TAG,
        `updateSettingsDataScene. isSceneFault:${isSceneFault} isOpenFault:${isOpenFault} isOperateFault:${isOperateFault}`);
      return false;
    }
    return true;
  }

  /**
   * 模式切换时同步实况通知数据到 SettingsData
   * @param scene 目标模式
   * @param preScene 切换前模式
   */
  private updateLiveViewNotifyData(scene: string, preScene: string): void {
    if (scene !== NO_SCENE) {
      LiveViewManager.sendLiveView(scene);
      return;
    }
    if (preScene !== NO_SCENE) {
      LiveViewManager.cancelLiveView(preScene);
    }
  }

  /**
   * 更新来电勿扰相关配置
   * @param scene
   */
  private updateIncomingConfig(scene: string): void {
    LogUtil.showInfo(TAG, `updateIncomingConfig scene: ${scene}`);
    AllowDisturbManager.getInstance().getEl1ContactPolicy(scene).then((contactPolicy) => {
      LogUtil.showInfo(TAG, `updateIncomingConfig contactPolicy: ${contactPolicy}`);
      SettingsDataUtils.setSystemValue(SettingsDataKeyConstant.CALL_MESSAGE_POLICY, contactPolicy);
    });

    this.updateRepeatCallersConfig(scene);
  }

  /**
   * 按模式配置下发重复来电响铃开关
   *
   * @param scene 模式id
   */
  private updateRepeatCallersConfig(scene: string): void {
    const isSupportNotDisturb: boolean =
      scene !== NO_SCENE && ModeConfigAdapter.getInstance().getConfigByModeId(scene).isSupportNotDisturb;
    if (!isSupportNotDisturb) {
      LogUtil.showInfo(TAG, `updateRepeatCallersConfig close, scene: ${scene}`);
      SettingsDataUtils.setSystemValue(SettingsDataKeyConstant.REPEAT_CALLERS_ENABLE, CLOSE);
      return;
    }
    AllowDisturbManager.getInstance().getRepeatCallRingState(scene).then((enable: boolean) => {
      LogUtil.showInfo(TAG, `updateRepeatCallersConfig repeatCallRing: ${enable}`);
      SettingsDataUtils.setSystemValue(SettingsDataKeyConstant.REPEAT_CALLERS_ENABLE, enable ? OPEN : CLOSE);
    });
  }

  /**
   * 通知内部模块进行模式切换
   *
   * @param currentScene 当前开启模式
   * @param nextScene 待切换模式Id
   * @param operType 类型
   */
  private notifyToUpdateScene(currentScene: string, nextScene: string, operType: number): void {
    if (nextScene === NO_SCENE) {
      this.notifyToStopScene(currentScene, operType);
      return;
    }
    if (currentScene === NO_SCENE) {
      this.notifyToStartScene(nextScene, operType);
    } else {
      this.notifyToChangeScene(nextScene, operType);
    }
  }

  /**
   * 通知模式启动
   *
   * @param nextScene 待切换模式Id
   * @param operType 类型
   */
  private notifyToStartScene(scene: string, operType: number): void {
    LogUtil.showInfo(TAG, `notifyToStartScene, scene: ${scene}`);
    EventBus.getInstance().emit(EventBusNameConstant.MODE_START_EVENT, scene, operType);
    // 直接生效关联设置（深色/护眼等），避免仅依赖 UI 进程 EventBus 监听
    void SettingLinkageManager.getInstance().onModeStarted(scene);
  }

  /**
   * 通知模式切换
   *
   * @param nextScene 待切换模式Id
   * @param operType 类型
   */
  private notifyToChangeScene(scene: string, operType: number): void {
    LogUtil.showInfo(TAG, `notifyToChangeScene, scene: ${scene}`);
    EventBus.getInstance().emit(EventBusNameConstant.MODE_CHANGE_EVENT, scene, operType);
    void SettingLinkageManager.getInstance().onModeStarted(scene);
  }

  /**
   * 通知关闭模式
   *
   * @param nextScene 待切换模式Id
   * @param operType 类型
   */
  private notifyToStopScene(scene: string, operType: number): void {
    LogUtil.showInfo(TAG, `notifyToStopScene, scene: ${scene}`);
    EventBus.getInstance().emit(EventBusNameConstant.MODE_STOP_EVENT, scene, operType);
    void SettingLinkageManager.getInstance().onModeStopped(scene);
  }
}