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
import { common, Want } from '@kit.AbilityKit';
import { BusinessError, systemDateTime, systemParameterEnhance } from '@kit.BasicServicesKit';
import {
  ActivateType,
  Constants,
  ORIGIN_PRESET_FRAGMENT,
  PRESET_RES_THEME,
  TARGET_AOD,
  TARGET_FONT,
  TARGET_HOME,
  TARGET_LOCK,
  TARGET_SKIN,
  TargetType,
  ThemeCode,
  ThemeInfo,
  ThemeOptions,
  ThemePackInfo,
  TrialContentType,
  TrialRollbackType
} from '@ohos/themeservice_inner_api/Index';
import { FileUtil, NullableType, StringUtils, TsLog } from '@ohos/themeservicebase/Index';
import { ThemeCacheInfo, ThemeEditInfo, ThemeExtendInfo } from '../../cache/ThemeInfoStoreCache';
import { RollbackThemeInfo, ThemeTrialCache, TrialCacheData } from '../../cache/ThemeTrialCache';
import {
  NOTIFY_THEME_APP_EXPIRES,
  NOTIFY_THEME_APP_EXPIRES_ADVANCED,
  RESULT_TO_THEME_APP_UI,
  TrialExpiresResult,
  TSRemoteCaller
} from '../../remote/caller/TSRemoteCaller';
import { PreThemeInfo } from '../../remote/model/PreThemeInfo';
import { TrialThemeInfo } from '../../remote/model/TrialThemeInfo';
import { ActivatedThemeUtil } from '../../util/ActivatedThemeUtil';
import { TSPathUtils } from '../../util/TSPathUtils';
import { PathValidateUtil } from '../../validate/PathValidateUtil';
import { ThemeTrialService } from '../api/ThemeTrialService';
import { FontInfo } from '../model/FontInfo';
import { activateThemeService, ThemeActivateServiceImpl } from './ThemeActivateServiceImpl';
import { themeInfoService } from './ThemeInfoServiceImpl';
import { tsTimer } from './TsTimerImpl';
import { ThemePackageInstaller } from './activate/installer/ThemePackgeInstaller';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';

const TAG: string = 'ThemeTrialServiceImpl';

interface TimerResult {
  id: number;

  endTime: number;
}

class TsFreeThemeTimer {
  /**
   * 试用到期兜底时间
   */
  private static readonly FINAL_TRIAL_TIME: number = 10 * 60 * 1000;

  /**
   * 大桌面进程重启，试用到期回调延时调用时间，解决大桌面未完全启动时，无法拉起主题App问题
   */
  private static readonly SCB_RESTART_DELAY_TIME: number = 60 * 1000;

  private timerId?: number;

  public async startInitTimer(onTimer: () => void): Promise<void> {
    if (this.timerId) {
      await tsTimer.get().stopTimer(this.timerId);
    }
    let result: TimerResult = await this.startTimer(TsFreeThemeTimer.SCB_RESTART_DELAY_TIME, onTimer);
    this.timerId = result.id;
  }

  public async startFinalTimer(onTimer: () => void): Promise<void> {
    if (this.timerId) {
      await tsTimer.get().stopTimer(this.timerId);
    }
    let result: TimerResult = await this.startTimer(TsFreeThemeTimer.FINAL_TRIAL_TIME, onTimer);
    this.timerId = result.id;
  }

  public async startTimer(leftDuration: number, onTimer: () => void): Promise<TimerResult> {
    let currentRealTime: number = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
    let endTime: number = currentRealTime + leftDuration;
    let id: Nullable<number> = await tsTimer.get().startTimer({
      endTime: endTime,
      onTimer
    });
    return {
      id: id ?? 0,
      endTime: endTime
    }
  }

  public async stopTimer(cacheData: TrialCacheData): Promise<void> {
    let timerIds: Nullable<number>[] = [this.timerId, cacheData.endTimerId, cacheData.reminderTimerId];
    for (const id of timerIds) {
      if (id) {
        await tsTimer.get().stopTimer(id);
      }
    }
    this.timerId = undefined;
  }
}

const timer: TsFreeThemeTimer = new TsFreeThemeTimer();

/**
 * 主题试用服务具体实现，非单例
 */
export class ThemeTrialServiceImpl implements ThemeTrialService {
  async isTrialTheme(themeEditorId: string): Promise<boolean> {
    if (StringUtils.isEmpty(themeEditorId)) {
      return false;
    }
    let trialCacheData: Nullable<TrialCacheData> = await ThemeTrialCache.getInstance().get();
    if (trialCacheData &&
    StringUtils.equals(trialCacheData.trialType, 'theme') &&
    StringUtils.equals(trialCacheData.trialThemeEditorId, themeEditorId)) {
      // 当前主题是试用主题
      return true;
    }
    return false
  }

  async getTrialTheme(): Promise<TrialThemeInfo> {
    let trialCacheData: NullableType<TrialCacheData> = await ThemeTrialCache.getInstance().get();
    if (trialCacheData) {
      TsLog.info(TAG, `getTrialTheme`);
      let trialThemeInfo: TrialThemeInfo = {
        trialThemeId: trialCacheData.trialType === 'font'
          ? trialCacheData.trialFontId // 当前试用字体id
          : trialCacheData.trialThemeId, // 当前试用主题id
        trialType: trialCacheData.trialType,
        trialEndTime: trialCacheData.endTime,
        reminderEndTime: trialCacheData.reminderTime,
        activateType: trialCacheData.activateType,
        preThemeInfo: this.toPreThemeInfo(trialCacheData.rollbackThemeInfo)
      };
      return trialThemeInfo;
    }
    TsLog.info(TAG, `getTrialTheme is null`);
    return {};
  }

  async activateTrialTheme(path: string, trialDuration: number, contentType: TrialContentType,
    activateType: ActivateType,
    reminderDuration?: number): Promise<number> {
    return this.activateFreeTheme(activateType, contentType, path, trialDuration, reminderDuration);
  }

  private async activateFreeTheme(activateType: ActivateType, contentType: TrialContentType, path: string,
    endDuration: number, reminderDuration?: number): Promise<number> {
    const pathEnable: boolean = await PathValidateUtil.validatePath(path);
    if (!pathEnable) {
      TsLog.error(TAG, `Activate trial  ${activateType} ${contentType} failed , path validate failed`)
      const error: BusinessError<string> = {
        name: 'error',
        message: `Activate trial  ${activateType} ${contentType} failed , path validate failed`,
        code: RemoteCode.ERR_ILLEGAL_PATH
      };
      return Promise.reject(error);
    }
    TsLog.info(TAG, `Activate ${activateType} ${contentType} start , endDuration = ${endDuration}`);
    // 第一步：创建待回退主题/字体信息
    let rollbackTheme: RollbackThemeInfo = await this.initRollbackTheme(contentType);
    // 第二步：使能试用主题/字体
    try {
      contentType === 'font' ? await this.enableTrialFont(path) : await this.enableTrialTheme(path);
    } catch (err) {
      TsLog.error(TAG, `Activate trial ${contentType} failed`)
      return Promise.reject(err);
    }
    // 第三步：创建试用主题/字体信息
    let trialCacheData: TrialCacheData =
      await this.startFreeTheme(activateType, contentType, rollbackTheme, endDuration, reminderDuration);
    // 第四步：缓存试用信息
    await ThemeTrialCache.getInstance().update(trialCacheData);
    TsLog.info(TAG, `Activate ${activateType} ${contentType} success`)
    return ThemeCode.SUCCESS;
  }

  async promoteFreeTheme(id: string, path: string, contentType: TrialContentType): Promise<number> {
    // 获取正在试用主题/字体信息
    let trialCacheData: NullableType<TrialCacheData> = await ThemeTrialCache.getInstance().get();
    if (!trialCacheData || contentType !== trialCacheData.trialType) {
      // 不存在试用信息或者升级资源类型与试用资源类型不同
      TsLog.info(TAG,
        `Promote theme failed , ${trialCacheData?.activateType} contentType = ${contentType} , cache type = ${trialCacheData?.trialType}`);
      return ThemeCode.ERROR_PROMOTE_TRIAL_THEME;
    }
    const validate: boolean = await PathValidateUtil.validatePath(path);
    if (!validate) {
      TsLog.warning(TAG, `promoteTrialTheme path validate fail:${path}`);
      return ThemeCode.ERROR_PROMOTE_TRIAL_THEME;
    }
    let currentTrialId: string = contentType === 'font'
      ? trialCacheData.trialFontId ?? ''
      : trialCacheData.trialThemeId ?? '';
    if (currentTrialId !== id) {
      // 升级资源id与试用资源id不同
      TsLog.info(TAG, `Promote theme failed , trialId not equal`);
      return ThemeCode.ERROR_PROMOTE_TRIAL_THEME;
    }
    // 试用资源升级转正
    TsLog.info(TAG, `Promote trial ${contentType} start`);
    // 更新正在应用主题信息缓存
    if (contentType === 'theme') {
      let currentCacheTheme: NullableType<ThemeCacheInfo> = await themeInfoService.get().getCurrentCacheTheme();
      TsLog.info(TAG, `promoteFreeTheme id : ${id}, currentCacheTheme.id : ${currentCacheTheme?.id}`);
      if (currentCacheTheme && currentCacheTheme.id === id) {
        currentCacheTheme.srcPath = path;
        await themeInfoService.get().updateCurrentCacheTheme(currentCacheTheme);
      }
    }
    // 停止定时器
    timer.stopTimer(trialCacheData);
    // 清除试用缓存
    await ThemeTrialCache.getInstance().clear();
    TsLog.info(TAG, `Promote ${trialCacheData?.activateType} ${contentType} success`);
    return ThemeCode.SUCCESS;
  }

  async onInit(): Promise<void> {
    // 获取当前试用主题/字体信息
    let trialCacheData: NullableType<TrialCacheData> = await ThemeTrialCache.getInstance().get();
    if (!trialCacheData) { // 当前不存在试用主题/字体
      TsLog.info(TAG, `onInit Delay check trial expire not need, no trialCacheData.`);
      return;
    }
    TsLog.info(TAG, `onInit, Delay check trial expire`);
    timer.startInitTimer(() => this.notifyThemeAppRestart());
  }

  async rollbackTheme(trialRollbackType: TrialRollbackType): Promise<number> {
    try {
      // 获取正在试用主题/字体信息
      let trialCacheData: NullableType<TrialCacheData> = await ThemeTrialCache.getInstance().get();
      if (!trialCacheData) {
        // 无正在试用，返回失败
        TsLog.info(TAG, `Rollback failed , trialRollbackType = ${trialRollbackType}, trialCacheData is null`);
        return ThemeCode.ERROR_ROLLBACK_THEME;
      }
      // 停止试用
      TsLog.info(TAG, `Rollback ${trialCacheData.trialType} , trialRollbackType = ${trialRollbackType}`);
      await this.stopTrial(trialCacheData);
      // 返回上一个主题/字体
      if (trialRollbackType === 'prev' && trialCacheData.rollbackThemeInfo) {
        await this.rollbackPrev(trialCacheData.trialType, trialCacheData.rollbackThemeInfo);
        return ThemeCode.SUCCESS;
      }
      // 其他场景，兜底回退
      await this.rollbackDefault(trialCacheData.trialType);
      return ThemeCode.SUCCESS;
    } catch (err) {
      TsLog.error(TAG, `rollbcakTheme err`, err);
      return Promise.reject(err);
    }
  }

  async stopTrialTheme(trialType: TrialContentType): Promise<void> {
    // 获取正在试用主题/字体信息
    let trialCacheData: NullableType<TrialCacheData> = await ThemeTrialCache.getInstance().get();
    if (!trialCacheData) {
      // 不存在试用
      return;
    }
    // 存在试用资源，当前使能的同类型资源，停止原来试用资源
    if (trialType === trialCacheData.trialType) {
      TsLog.info(TAG, `Stop trial , trialType = ${trialType}`);
      await this.stopTrial(trialCacheData, false);
      return;
    }
    // 使能普通主题，存在试用字体，如果普通主题中字体发生变化，停止原来的试用字体
    if (trialType === 'theme' && trialCacheData.trialType === 'font') {
      let currentFont: FontInfo = await themeInfoService.get().getCurrentFont();
      if (currentFont?.id !== trialCacheData.trialFontId) {
        TsLog.info(TAG, `Stop trial , font is change`);
        await this.stopTrial(trialCacheData, false);
      }
    }
  }

  /**
   * 创建待回退主题/字体信息
   * @param {TrialContentType} trialType 试用类型 theme：试用主题， font：试用字体
   * @return {RollbackThemeInfo} 待回退主题信息
   */
  private async initRollbackTheme(contentType: TrialContentType): Promise<RollbackThemeInfo> {
    TsLog.info(TAG, `Init rollback ${contentType}`);
    // 获取正在试用主题/字体信息
    let trialCacheData: NullableType<TrialCacheData> = await ThemeTrialCache.getInstance().get();
    if (trialCacheData && trialCacheData.rollbackThemeInfo) { // 有正在试用
      if (trialCacheData.trialType === contentType) {
        // 试用类型相同，用缓存作为回退主题信息
        return trialCacheData.rollbackThemeInfo;
      } else {
        // 试用类型不同，先回退之前试用
        await this.rollbackTheme('default');
      }
    }
    // 无正在试用，获取当前主题/字体信息作为回退主题信息
    let rollbackTheme: RollbackThemeInfo;
    if (contentType === 'font') {
      rollbackTheme = await this.createRollbackFont();
    } else {
      rollbackTheme = await this.createRollbackTheme();
    }
    return rollbackTheme;
  }

  /**
   * 创建待回退主题信息
   */
  private async createRollbackTheme(): Promise<RollbackThemeInfo> {
    let rollbackTheme: RollbackThemeInfo = new RollbackThemeInfo();
    let currentThemeCacheInfo: NullableType<ThemeCacheInfo> = await themeInfoService.get().getCurrentCacheTheme();
    if (currentThemeCacheInfo) {
      // 当前主题在画廊中的编辑ID
      rollbackTheme.editorId = currentThemeCacheInfo.editorId;
      // 获取在线主题id
      if (currentThemeCacheInfo.originType === 'online') {
        rollbackTheme.themeId = currentThemeCacheInfo.id;
      }
      // 获取混搭在线资源id
      if (currentThemeCacheInfo.themeEditInfo && currentThemeCacheInfo.themeEditInfo.size > 0) {
        rollbackTheme.aodId = this.getOnlineId(currentThemeCacheInfo.themeEditInfo, TARGET_AOD);
        rollbackTheme.fontId = this.getOnlineId(currentThemeCacheInfo.themeEditInfo, TARGET_FONT);
        rollbackTheme.homeId = this.getOnlineId(currentThemeCacheInfo.themeEditInfo, TARGET_HOME);
        rollbackTheme.lockId = this.getOnlineId(currentThemeCacheInfo.themeEditInfo, TARGET_LOCK);
        rollbackTheme.skinId = this.getOnlineId(currentThemeCacheInfo.themeEditInfo, TARGET_SKIN);
      }
    }
    return rollbackTheme;
  }

  /**
   * 创建待回退字体信息
   */
  private async createRollbackFont(): Promise<RollbackThemeInfo> {
    let rollbackTheme: RollbackThemeInfo = new RollbackThemeInfo();
    let fontInfo: FontInfo = await themeInfoService.get().getCurrentFont();
    rollbackTheme.fontId = fontInfo.id;
    rollbackTheme.fontOrigin = fontInfo.origin;
    rollbackTheme.fontPath = fontInfo.ttfFileSrc;
    rollbackTheme.fontPathExt = fontInfo.ttfFileSrcExt;
    return rollbackTheme;
  }

  /**
   * 从混搭主题信息中获取在线
   * @param themeEditInfoMap 混搭主题信息Map
   * @param targetType 资源类型
   */
  private getOnlineId(themeEditInfoMap: ThemeEditInfo, targetType: TargetType): Nullable<string> {
    let item: ThemeExtendInfo | undefined = themeEditInfoMap.get(targetType);
    if (item && item.type === 'online') {
      return item.resourceId;
    } else {
      return undefined;
    }
  }

  /**
   * 使能字体
   * @param path 资源包路径
   */
  private async enableTrialFont(path: string): Promise<boolean> {
    try {
      TsLog.info(TAG, `Enable trial font start`);
      // 使能字体需要传配置项
      let option: ThemeOptions = new ThemeOptions();
      option.enableFont();
      try {
        // false：不加入到当前主题的混搭信息中
        await activateThemeService().activateTheme(path, option, false);
      } catch (err) {
        // 使能字体失败
        TsLog.error(TAG, `Enable trial font failed`)
        return Promise.reject(err);
      }
      // 使能字体成功，删除试用字体资源包
      await FileUtil.rmdirAsync(path);
      TsLog.info(TAG, `Enable trial font success`);
      return true;
    } catch (err) {
      TsLog.error(TAG, `Enable trial font catch exception`, err)
      return Promise.reject(err);
    }
  }

  /**
   * 使能主题
   * @param path 资源包路径
   */
  private async enableTrialTheme(path: string): Promise<boolean> {
    try {
      TsLog.info(TAG, `Enable trial theme start`);
      let eid: string = systemDateTime.getTime(true).toString();
      const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(path, eid);
      if (themeInfo?.id === '') {
        TsLog.error(TAG, `enable trial theme id is empty`);
        const error: BusinessError<string> =
          { name: 'error', message: `enable trial theme id is empty`, code: RemoteCode.ERR_THEME_ID };
        return Promise.reject(error);
      }
      const activeResult: number = await new ThemePackageInstaller(themeInfo).activateThemeOpt(undefined, true);
      if (activeResult === RemoteCode.SUCCESS) {
        await themeInfoService.get().applyTheme(themeInfo, undefined, false);
        // 更新正在应用主题信息缓存，使用ab目录中路径作为作为主题缓存信息中的主题资源包路径
        let srcPath: string = `${ActivatedThemeUtil.getActivatedThemePath()}system`;
        let currentCacheTheme: NullableType<ThemeCacheInfo> = await themeInfoService.get().getCurrentCacheTheme();
        TsLog.info(TAG, `enableTrialTheme currentCacheTheme.id : ${currentCacheTheme?.id}`);
        if (currentCacheTheme) {
          currentCacheTheme.srcPath = srcPath;
          await themeInfoService.get().updateCurrentCacheTheme(currentCacheTheme);
        }
        // 通知刷新小画廊
        ActivatedThemeUtil.notifyApplyTheme();
        // 使能主题成功，删除试用主题资源包
        await FileUtil.rmdirAsync(path);
        TsLog.info(TAG, `Enable trial theme success`);
        return true;
      } else {
        // 使能主题失败
        TsLog.error(TAG, `Enable trial theme failed`);
        const error: BusinessError<string> =
          { name: 'error', message: `Enable trial theme failed`, code: activeResult };
        return Promise.reject(error);
      }
    } catch (err) {
      TsLog.error(TAG, `Enable trial theme catch exception`, err)
      return Promise.reject(err);
    }
  }

  /**
   * 创建试用主题/字体信息（包含启动定时器等逻辑）
   * @param {TrialContentType} trialType 试用类型 theme：试用主题， font：试用字体
   * @param {number} trialDuration 试用时长，单位ms
   * @param {RollbackThemeInfo} rollbackTheme 待回退主题信息
   * @return {TrialCacheData} 正在试用的主题信息
   */
  private async startFreeTheme(activateType: ActivateType, contentType: TrialContentType,
    rollbackTheme: RollbackThemeInfo, endDuration: number, reminderDuration?: number): Promise<TrialCacheData> {
    TsLog.info(TAG, `Start trial ${activateType} ${contentType} timer`);
    // 第一步：处理原试用主题/字体信息
    let trialCacheData: NullableType<TrialCacheData> = await ThemeTrialCache.getInstance().get();
    if (trialCacheData) { // 停止试用
      await this.stopTrial(trialCacheData);
    }
    // 第二步：创建新的试用主题/字体信息
    trialCacheData = new TrialCacheData();
    // 设置回退信息
    trialCacheData.activateType = activateType;
    trialCacheData.trialType = contentType;
    trialCacheData.rollbackThemeInfo = rollbackTheme;
    if (contentType === 'font') {
      // 获取当前字体信息，设置试用信息
      let currentFont: FontInfo = await themeInfoService.get().getCurrentFont();
      trialCacheData.trialFontId = currentFont?.id
    } else {
      // 获取当前主题信息，设置试用信息
      let currentTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      trialCacheData.trialThemeId = currentTheme?.id;
      trialCacheData.trialThemeEditorId = currentTheme?.editorId;
    }
    // 第三步：启动试用到期定时器
    if (endDuration > 0) {
      // 到期结束时间，试用开机时长
      let timerResult: TimerResult = await timer.startTimer(endDuration, () => {
        // 到期回调通知主题App
        this.notifyThemeAppExpires();
      });
      trialCacheData.endTimerId = timerResult.id;
      trialCacheData.endTime = timerResult.endTime;
    }

    // 第四步：启动试用提醒定时器
    if (reminderDuration && reminderDuration > 0) {
      let timerResult: TimerResult = await timer.startTimer(reminderDuration, () => {
        TsLog.debug(TAG, `reminder Timer Expired`);
        this.notifyThemeAppAdvanced();
      });
      trialCacheData.reminderTimerId = timerResult.id;
      trialCacheData.reminderTime = timerResult.endTime;
    }
    return trialCacheData;
  }

  /**
   * 回退上一个主题/字体
   * @param trialType 试用类型 theme：试用主题， font：试用字体
   * @param rollbackTheme 回退信息
   */
  private async rollbackPrev(trialType: TrialContentType, rollbackTheme: RollbackThemeInfo): Promise<void> {
    try {
      if (trialType === 'font') {
        // 回退字体
        let isFontFileExists: boolean = FileUtil.isFileExists(rollbackTheme.fontPath);
        if (isFontFileExists && rollbackTheme.fontId !== undefined &&
          rollbackTheme.fontPath !== undefined && rollbackTheme.fontOrigin !== undefined) {
          // 回退字体存在
          TsLog.info(TAG, `Rollback prev , font`);
          await activateThemeService().applyFont(rollbackTheme.fontId, rollbackTheme.fontPath,
            rollbackTheme.fontOrigin, rollbackTheme.fontPathExt);
        } else {
          // 回退字体被删除，回退默认字体
          TsLog.info(TAG, `Rollback prev , reset default font`);
          await activateThemeService().activateDefaultFont();
        }
      } else {
        // 回退主题
        let themeInfo: NullableType<ThemeInfo> =
          await themeInfoService.get().getThemeByEditorId(rollbackTheme.editorId ?? '');
        if (themeInfo && await this.checkPrevTheme(themeInfo)) {
          // 回退主题在画廊中存在 且 回退主题原始包非预置主题小包
          TsLog.info(TAG, `Rollback prev , theme`);
          await activateThemeService().activateEditedTheme(themeInfo.editorId);
        } else {
          // 回退主题被删除，回退默认主题
          TsLog.info(TAG, `Rollback prev , reset default theme`);
          await activateThemeService().activateDefaultTheme();
        }
      }
    } catch (err) {
      TsLog.error(TAG, `rollbackPrev err`, err);
      return Promise.reject(err);
    }
  }

  /**
   * 回退系统预置
   * @param trialType 试用类型 theme：试用主题， font：试用字体
   */
  private async rollbackDefault(trialType: TrialContentType): Promise<void> {
    TsLog.info(TAG, `Rollback default ${trialType}`);
    if (trialType === 'font') {
      // 回退字体
      await activateThemeService().activateDefaultFont();
    } else {
      // 回退主题
      await activateThemeService().activateDefaultTheme();
    }
  }

  /**
   * 停止试用
   * @param trialCacheData 需要停止试用的主题/字体信息
   */
  private async stopTrial(trialCacheData: TrialCacheData, notifyChange: boolean = true) {
    TsLog.info(TAG, `Stop and clean trial cache , trialType = ${trialCacheData.trialType}`);
    // 停止定时器
    timer.stopTimer(trialCacheData);
    // 清除试用缓存
    await ThemeTrialCache.getInstance().clear();
    // 清除主题画廊缓存中试用主题信息
    if (trialCacheData.trialType === 'theme') {
      // 画廊数据中移除已经在试用的主题
      themeInfoService.get().removeTheme([trialCacheData.trialThemeEditorId ?? ''], notifyChange);
    }
  }

  /**
   * 回退信息类转换成对外接口传递数据类
   */
  private toPreThemeInfo(rollbackThemeInfo?: RollbackThemeInfo): PreThemeInfo {
    let preThemeInfo: PreThemeInfo = {
      themeId: rollbackThemeInfo?.themeId,
      fontId: rollbackThemeInfo?.fontId,
      aodId: rollbackThemeInfo?.aodId,
      homeId: rollbackThemeInfo?.homeId,
      lockId: rollbackThemeInfo?.lockId,
      skinId: rollbackThemeInfo?.skinId,
    };
    return preThemeInfo;
  }

  /**
   * 通知主题App到期（进程重启）
   */
  public async notifyThemeAppRestart(): Promise<void> {
    this.notifyThemeAppWithRollback((freeType, contentType, contentId, preThemeInfo) => {
      if (freeType === Constants.TRIAL) {
        return TSRemoteCaller.notifyTrialExpires(contentType, contentId, preThemeInfo);
      }
      if (freeType === Constants.LIMITED_FREE) {
        TsLog.debug(TAG, `notifyThemeAppRestart LimitedFree`);
        return TSRemoteCaller.notifyCorrectLimiteFreeDuration();
      }
      return Promise.resolve(undefined);
    })
  }

  /**
   * 通知主题App到期（试用到期）
   */
  public async notifyThemeAppExpires(): Promise<void> {
    this.notifyThemeAppWithRollback((freeType, contentType, contentId, preThemeInfo) => {
      if (freeType === Constants.TRIAL) {
        return TSRemoteCaller.notifyTrialExpires(contentType, contentId, preThemeInfo);
      }
      if (freeType === Constants.LIMITED_FREE) {
        return TSRemoteCaller.noticeLimitFree(contentType, contentId, preThemeInfo, NOTIFY_THEME_APP_EXPIRES);
      }
      return Promise.resolve(undefined);
    })
  }

  /**
   * 提前通知主题App
   */
  public async notifyThemeAppAdvanced(): Promise<void> {
    this.notifyThemeApp((freeType, contentType, contentId, preThemeInfo) => {
      if (freeType === Constants.LIMITED_FREE) {
        return TSRemoteCaller.noticeLimitFree(contentType, contentId, preThemeInfo, NOTIFY_THEME_APP_EXPIRES_ADVANCED);
      }
      return Promise.resolve(undefined);
    })
  }

  private async notifyThemeApp(notifier: (activateType: ActivateType, contentType: TrialContentType,
    contentId: string, preThemeInfo: PreThemeInfo) => Promise<TrialExpiresResult | undefined>): Promise<void> {
    // 获取当前试用主题/字体信息
    let freeCacheData: NullableType<TrialCacheData> = await ThemeTrialCache.getInstance().get();
    if (!freeCacheData) { // 当前不存在试用主题/字体
      TsLog.info(TAG, `Notify theme app not need   , trial cache is null`);
      return;
    }
    // 当前试用的不是正在使能的主题/字体
    if (!await this.isUsingFree(freeCacheData)) {
      TsLog.warning(TAG, `${freeCacheData.activateType} ${freeCacheData.trialType} is not using, stop.`);
      this.stopTrial(freeCacheData);
      return;
    }

    TsLog.info(TAG, `Notify theme app`);
    let contentId: string = freeCacheData.trialType === 'font'
      ? freeCacheData.trialFontId ?? ''
      : freeCacheData.trialThemeId ?? '';
    // 通知主题App服务
    let result: TrialExpiresResult | undefined;
    try {
      let preThemeInfo: PreThemeInfo = this.toPreThemeInfo(freeCacheData.rollbackThemeInfo);
      result = await notifier(freeCacheData.activateType, freeCacheData.trialType, contentId, preThemeInfo);
    } catch (e) {
      result = undefined;
      TsLog.warning(TAG, `Notify theme app error`, e);
    }
    // 无结果或者主题App处理失败，日志打印
    if (!result || !result.returnValue) {
      TsLog.error(TAG, `Result Error, result = ${result}`);
    }
  }

  private async notifyThemeAppWithRollback(notifier: (activateType: ActivateType, contentType: TrialContentType,
    contentId: string, preThemeInfo: PreThemeInfo) => Promise<TrialExpiresResult | undefined>): Promise<void> {
    // 获取当前试用主题/字体信息
    let freeCacheData: NullableType<TrialCacheData> = await ThemeTrialCache.getInstance().get();
    if (!freeCacheData) { // 当前不存在试用主题/字体
      TsLog.info(TAG, `Notify theme app not need   , trial cache is null`);
      return;
    }
    // 当前试用的不是正在使能的主题/字体
    if (!await this.isUsingFree(freeCacheData)) {
      TsLog.warning(TAG, `${freeCacheData.activateType} ${freeCacheData.trialType} is not using, stop.`);
      this.stopTrial(freeCacheData);
      return;
    }

    TsLog.info(TAG, `Notify theme app`);
    await this.startFinalTimer();
    let contentId: string = freeCacheData.trialType === 'font'
      ? freeCacheData.trialFontId ?? ''
      : freeCacheData.trialThemeId ?? '';
    // 通知主题App服务
    let result: TrialExpiresResult | undefined;
    try {
      let preThemeInfo: PreThemeInfo = this.toPreThemeInfo(freeCacheData.rollbackThemeInfo);
      result = await notifier(freeCacheData.activateType, freeCacheData.trialType, contentId, preThemeInfo);
    } catch (e) {
      result = undefined;
      TsLog.warning(TAG, `Notify theme app error`, e);
    }
    // 主题App服务无法拉起主题APP界面,由Ts拉起主题APP界面
    if (result && result.errCode === RESULT_TO_THEME_APP_UI) {
      this.startThemeAppUiAbility(freeCacheData);
    }
    // 无结果或者主题App处理失败，直接回退预置主题/字体信息
    if (!result || !result.returnValue) {
      this.rollbackTheme('default');
    }
  }

  private async isUsingFree(freeCacheData: TrialCacheData): Promise<boolean> {
    if (freeCacheData.trialType === 'font') {
      let fontInfo: FontInfo = await themeInfoService.get().getCurrentFont();
      return StringUtils.equals(fontInfo.id, freeCacheData.trialFontId);
    } else {
      let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      return StringUtils.equals(themeInfo.id, freeCacheData.trialThemeId);
    }
  }

  /**
   * 启动主题App界面
   * @param trialCacheData
   */
  private startThemeAppUiAbility(trialCacheData: TrialCacheData): void {
    TsLog.info(TAG, `Start ThemeApp UiAbility , trialType = ${trialCacheData.trialType}`);
    let contentId: string = trialCacheData.trialType === 'font'
      ? trialCacheData.trialFontId ?? ''
      : trialCacheData.trialThemeId ?? '';
    const want: Want = {
      bundleName: 'com.ohos.thememanager',
      uri: `theme://com.ohos.thememanager?page=detail_page&contentType=${trialCacheData.trialType}&contentId=${contentId}&addMainPage=true`
    };
    const context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
    context.startAbility(want, (error) => {
      TsLog.info(TAG, `Start ThemeApp UiAbility , code = ${error.code}`);
    });
  }

  /**
   * 启动兜底定时器，10分钟后到期，直接回退预置主题/字体信息
   * @param trialCacheData
   */
  private async startFinalTimer(): Promise<void> {
    TsLog.info(TAG, `Start final time`);
    timer.startFinalTimer(() => {
      // 到期回退到预置
      TsLog.info(TAG, `final timer rollbackTheme`);
      this.rollbackTheme('default');
    })
  }

  async correctLimitedFreeTheme(id: string, contentType: TrialContentType, limitedDuration: number,
    reminderDuration: number): Promise<number> {
    // 获取正在限免主题/字体信息
    let limitedFreeCacheData: NullableType<TrialCacheData> = await ThemeTrialCache.getInstance().get();
    if (!limitedFreeCacheData || contentType !== limitedFreeCacheData.trialType) {
      // 不存在试用信息或者升级资源类型与试用资源类型不同
      TsLog.info(TAG,
        `Promote theme failed , ${limitedFreeCacheData?.activateType} contentType = ${contentType}, cache type = ${limitedFreeCacheData?.trialType}`);
      return ThemeCode.ERROR_PROMOTE_TRIAL_THEME;
    }

    // 校验缓存id信息
    if (id !== (contentType === 'theme' ? limitedFreeCacheData.trialThemeId : limitedFreeCacheData.trialFontId)) {
      // 缓存资源id不符
      TsLog.info(TAG,
        `CacheData theme id not matched , ${limitedFreeCacheData?.activateType} id = ${id} , cache id = ${(contentType ===
          'theme' ? limitedFreeCacheData.trialThemeId : limitedFreeCacheData.trialFontId)}`);
      return ThemeCode.ERROR_NOT_MATCHED_ID;
    }

    // 第一步，停止定时器
    timer.stopTimer(limitedFreeCacheData);

    // 第二步，重启试用到期定时器
    if (limitedDuration > 0) {
      // 到期结束时间，试用开机时长
      let timerResult: TimerResult = await timer.startTimer(limitedDuration, () => {
        // 到期回调通知主题App
        this.notifyThemeAppExpires();
      });
      limitedFreeCacheData.endTimerId = timerResult.id;
      limitedFreeCacheData.endTime = timerResult.endTime;
    } else {
      limitedFreeCacheData.endTimerId = undefined;
      limitedFreeCacheData.endTime = undefined;
    }

    // 第三步，重启试用提醒定时器
    if (reminderDuration > 0) {
      let timerResult: TimerResult = await timer.startTimer(reminderDuration, () => {
        this.notifyThemeAppAdvanced();
      });
      limitedFreeCacheData.reminderTimerId = timerResult.id;
      limitedFreeCacheData.reminderTime = timerResult.endTime;
    } else {
      limitedFreeCacheData.reminderTimerId = undefined;
      limitedFreeCacheData.reminderTime = undefined;
    }

    // 第四步：缓存试用信息
    await ThemeTrialCache.getInstance().update(limitedFreeCacheData);
    TsLog.info(TAG, `Correct LimitedFree ${contentType} success`)
    return ThemeCode.SUCCESS;
  }

  /**
   * 校验上一个主题包是否有效
   *
   * @param themeInfo 主题包信息
   * @returns true：主题包有效，false：主题包无效
   */
  public async checkPrevTheme(themeInfo: NullableType<ThemeInfo>): Promise<boolean> {
    if (themeInfo === null || themeInfo === undefined || themeInfo.editorId === undefined) { // 画廊缓存中不存在，无效
      TsLog.info(TAG, `Prev theme is null`);
      return false
    }
    if (themeInfo.originThemePack === null || themeInfo.originThemePack === undefined ||
      !FileUtil.isFileExists(themeInfo.originThemePack.srcPath)) { // 原始主题包不存在，无效
      TsLog.info(TAG, `Prev theme originThemePack is null`);
      return false
    }
    if (await this.isSmallPresetFragmentTheme(themeInfo)) { // 是预置主题小包，无效
      TsLog.info(TAG, `Prev theme originThemePack is small theme`);
      return false
    }
    return true;
  }

  /**
   * 判断原始主题包是否是预置主题小包
   * 预置主题小包不完整，完整的主题包需要通过主题App下载后应用
   *
   * @param themeInfo 主题包信息（不为空）
   * @returns true：原始主题包是预置的主题小包（条件1：description.json中origin值为presetFragment 条件2：在预置目录）
   */
  public async isSmallPresetFragmentTheme(themeInfo: ThemeInfo): Promise<boolean> {
    // 条件1：判断主题包类型为presetFragment
    let themePackInfo: NullableType<ThemePackInfo> = themeInfo.originThemePack;
    if (themePackInfo?.origin !== ORIGIN_PRESET_FRAGMENT) {
      TsLog.info(TAG, `Theme pack is not presetFragment , origin = ${themePackInfo?.origin}`);
      return false;
    }

    // 条件2：判断主题包原始路径是否为系统预置主题包目录
    const presetThemePathList: string[] = await TSPathUtils.getTsPresetRootPath(PRESET_RES_THEME);
    for (const presetThemeRootPath of presetThemePathList) {
      if (themePackInfo?.srcPath?.startsWith(presetThemeRootPath)) {
        TsLog.info(TAG, `Theme pack is small presetFragment`);
        return true;
      }
    }
    TsLog.info(TAG, `Theme pack is full presetFragment`);
    return false;
  }

  async stopTimer(): Promise<void> {
    TsLog.info(TAG, `stopTimer`);
    let trialCacheData: Nullable<TrialCacheData> = await ThemeTrialCache.getInstance().get();
    if (!trialCacheData) {
      TsLog.info(TAG, `stopTimer return. no trialCacheData`);
      return;
    }
    timer.stopTimer(trialCacheData);
  }

  async restartTimer(): Promise<void> {
    TsLog.info(TAG, `restartTimer`);
    let trialCacheData: Nullable<TrialCacheData> = await ThemeTrialCache.getInstance().get();
    if (!trialCacheData) {
      TsLog.info(TAG, `restartTimer return. no trialCacheData`);
      return;
    }
    timer.startInitTimer(() => this.notifyThemeAppRestart());
  }
}


/**
 * 试用服务，创建实现类，非单例
 * @returns {ThemeTrialService} 试用服务实现
 */
export function themeTrialService(): ThemeTrialService {
  return new ThemeTrialServiceImpl();
}