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

import { PrivacySensorViewData } from '../model/PrivacySensorViewData';
import { sMultimediaSubPageLayoutController, PageMode } from '../controller/MultimediaSubPageLayoutController';
// import privacyIndicatorManager from '@ohos.security.privacyIndicatorManager';
import bundleResourceManager from '@ohos.bundle.bundleResourceManager';
import bundleManager from '@ohos.bundle.bundleManager';
import mechanicManager from '@ohos.distributedHardware.mechanicManager';
import {
  AppStorageUtil,
  CheckEmptyUtils,
  DataProperty,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { ConfigurationEvent, GlobalContext } from '@ohos/frameworkwrapper';
import { LauncherAbilityManagerAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/LauncherAbilityManagerAdapter';
import { ControlCenterHiSysEventUtil } from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';
import { StubCameraManager } from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubCameraManager';
import {
  SOURCE_TYPE_LIVE
} from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubIsAcousticEchoCancelerSupported';
import i18n from '@ohos.i18n';
import { audio } from '@kit.AudioKit';
import { MeasureText } from '@kit.ArkUI';
import camera from '@ohos.multimedia.camera';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';

const TAG = 'Model.PrivacySensorViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DEFAULT_BUNDLE_NAME = 'default_bundle_name';
const INDICATOR_DETAIL_FLAG: number = 0x00000002;

/**
 * 隐私指示器ViewModel类
 */
export class PrivacySensorViewModel {
  private static privacySensorViewModel: PrivacySensorViewModel;
  private viewData: PrivacySensorViewData = new PrivacySensorViewData();
  private isSoundEffectRunning: boolean = false;

  public languageChangeListener = (event: ConfigurationEvent): void => {
    let systemLanguage = i18n.System.getSystemLanguage();
    this.viewData.isRTL = false;
    if (i18n.isRTL(systemLanguage)) {
      this.viewData.isRTL = true;
    }
    log.showInfo(`systemLanguage: ${systemLanguage} isRTL:${this.viewData.isRTL}`)
  }

  public updateCapturerCallback = (audioCapturerChangeInfoArray: Array<audio.AudioCapturerChangeInfo>): void => {
    if (CheckEmptyUtils.isEmptyArr(audioCapturerChangeInfoArray)) {
      return;
    }
    let newState: boolean = false;
    audioCapturerChangeInfoArray.forEach((capturerInfo) => {
      newState ||= capturerInfo?.capturerInfo.source === SOURCE_TYPE_LIVE &&
        capturerInfo?.capturerState === audio.AudioState.STATE_RUNNING;
      if (newState) {
        return;
      }
    });
    log.showInfo(`isSoundEffectRunning old: ${this.isSoundEffectRunning}, new: ${newState}`);
    if (this.isSoundEffectRunning !== newState) {
      this.isSoundEffectRunning = newState;
    }
  }

  public attachStateChangeCallback = (info: mechanicManager.AttachStateChangeInfo): void => {
    log.showInfo(`attachStateChangeCallback new state: ${info.state}`);
    let typeArray = this.viewData.multimediaSensorTypeArray.slice();
    typeArray[ControlCenterMultimediaType.BRACKET_KIT.valueOf()] = info.state === mechanicManager.AttachState.ATTACHED;
    this.viewData.multimediaSensorTypeArray = typeArray;
    this.viewData.isShowText = this.getIsShowText();
    this.updateTextMaxWidth();
    this.updateGeometryTransitionId();
    if (this.getMultimediaSensorIconCount() === 0 &&
      sMultimediaSubPageLayoutController.getPageMode() === PageMode.DETAIL) {
      sMultimediaSubPageLayoutController.hideWindow();
    }
  }

  /**
   * 初始化数据
   */
  public initData() {
    // 先调查询接口
    let userId: number = LauncherAbilityManagerAdapter.getUserId();
    log.showInfo(`userId: ${userId}`)
    try {
      /*privacyIndicatorManager.getPrivacyEventDetails(userId).then(async data => {
        this.viewData.isShowText = true;
        this.viewData.multimediaSensorTypeArray[ControlCenterMultimediaType.SOUND_EFFECT.valueOf()] =
          this.isSoundEffectRunning;
        this.viewData.multimediaSensorTypeArray[ControlCenterMultimediaType.VIDEO_EFFECT.valueOf()] =
          StubCameraManager.isControlCenterActive(camera.getCameraManager(GlobalContext.getContext()));
        this.updateGeometryTransitionId();
        if (data === undefined) {
          this.resetData()
          return;
        }
        let details: string = '';
        data.forEach((detail: ESObject) => {
          details += `${detail.bundleName} ${detail.showAccessState} ${detail.privacySensorType} ${detail.detailFlags},`;
        })
        log.showInfo(`getPrivacyEventDetails num: ${data.length}, details:${details}`)
        await this.washData(data);
        // 数据做一次保存
        AppStorageUtil.setOrCreate('privacyData', data, new DataProperty(true, true));
        if (data.length == 0) {
          log.showWarn(`after washData no data`)
          this.resetData()
          return;
        }
        this.updateData(data)
      })
        .catch((err: Error) => {
          log.error('getPrivacyEventDetails error', err);
        });*/
    } catch (err) {
      log.error('privacyIndicatorManager getData error', err)
    }
  }

  /**
   * 清洗数据，去除无效数据
   *
   * @param data
   */
  public async washData(data: Array<ESObject>) {
    let bundleAppName = '';
    this.viewData.isApplicationInterview = false;
    while (data.length > 0) {
      // 应用通过bundleName获取应用信息
      if ((data[0].detailFlags & INDICATOR_DETAIL_FLAG) === INDICATOR_DETAIL_FLAG) {
        bundleAppName = await this.getDeliverBundleInfoLabel(data[0].bundleName);
      } else {
        bundleAppName = await this.getBundleAppName(data[0].uid);
      }
      if (bundleAppName === DEFAULT_BUNDLE_NAME) {
        data.shift();
      } else {
        this.viewData.isApplicationInterview = true;
        break;
      }
    }
    this.viewData.recentAppName = bundleAppName;
  }

  public updateData(data: Array<ESObject>) {
    if (data === undefined) {
      return;
    }
    let accessedSensorTypeSet: Set<ESObject> = new Set();
    let accessingSensorTypeSet: Set<ESObject> = new Set();
    let accessedUidSet: Set<number> = new Set();
    let accessingUidSet: Set<number> = new Set();
    for (let i = 0; i < data.length; i++) {
      let privacyEventData: ESObject = data[i];
      /*if (privacyEventData.showAccessState === privacyIndicatorManager.AccessState.ACCESSING) {
        accessingSensorTypeSet.add(privacyEventData.privacySensorType);
        accessingUidSet.add(privacyEventData.uid);
      }
      if (privacyEventData.showAccessState === privacyIndicatorManager.AccessState.ACCESSED) {
        accessedSensorTypeSet.add(privacyEventData.privacySensorType);
        accessedUidSet.add(privacyEventData.uid);
      }*/
    }
    // 判断是否全是近期访问
    let isOnlyAccessed: boolean = accessingSensorTypeSet.size === 0;
    this.viewData.isOnlyAccessed = isOnlyAccessed;
    this.viewData.privacySensorTypeArray =
      isOnlyAccessed ? Array.from(accessedSensorTypeSet) : Array.from(accessingSensorTypeSet);
    this.viewData.isShowText = this.getIsShowText();
    if ((isOnlyAccessed && accessedUidSet.size > 1) || (!isOnlyAccessed && accessingUidSet.size > 1)) {
      this.viewData.recentAppName = ResUtils.getInnerStringNumS($r('app.string.privacy_sensor_multiple_application'),
        this.viewData.recentAppName);
    }
    if (isOnlyAccessed) {
      this.viewData.recentAppName = ResUtils.getInnerStringNumS($r('app.string.accessed_recently'),
        this.viewData.recentAppName);
    }
    this.updateTextMaxWidth();
    this.getPrivacySensorInfo();
  }

  private getPrivacySensorInfo(): void {
    let array = this.removeDuplicateData(this.viewData.privacySensorTypeArray);
    ControlCenterHiSysEventUtil.reportCCPrivacySensorShow({
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      PRIVACYSENSOR: this.viewData.isApplicationInterview ? 1 : 0,
      ACCESSINGPRIVACY: this.viewData.recentAppName,
      PERMISSIONPRIVACY: array.join(','),
    })
  }

  private removeDuplicateData(array: number[]): number[] {
    return Array.from(new Set(array));
  }

  public resetData() {
    this.viewData.privacySensorTypeArray = [];
    this.viewData.isApplicationInterview = false;
    this.viewData.recentAppName = '';
  }

  /**
   * 包管理的缓存刷新逻辑还没建设完成，先自定义包名获取方法
   * 后续需要切换ResourceManager的getBundleAppName方法
   *
   * @param uid
   * @returns
   */
  private async getBundleAppName(uid: number): Promise<string> {
    let resMgrName: string = '';
    try {
      let appIdentity = await bundleManager.getAppCloneIdentity(uid);
      let resourceInfo: bundleResourceManager.BundleResourceInfo =
        bundleResourceManager.getBundleResourceInfo(appIdentity.bundleName,
          bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL,
          appIdentity.appIndex);
      resMgrName = resourceInfo.label;
      log.showInfo('getBundleAppName uid:%{public}d , resMgrName: %{public}s', uid, resMgrName);
      return resMgrName;
    } catch (err) {
      log.error('getBundleAppName uid:' + uid + ' error:', err);
      return DEFAULT_BUNDLE_NAME;
    }
  }

  /**
   * 根据包名返回 bundleInfo
   *
   * @returns BundleInfo
   */
  private async getDeliverBundleInfo(bundleName: string): Promise<bundleManager.BundleInfo | null> {
    try {
      let bundleFlags: number = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT |
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;
      return await bundleManager.getBundleInfo(bundleName, bundleFlags);
    } catch (error) {
      log.showError(`getDeliverBundleInfo fail: ${error?.code} ${error?.message}`);
    }
    return null;
  }

  /**
   * 根据bundleInfo 返回 包label;
   *
   * @returns string
   */
  private async getDeliverApplicationLabel(bundleInfo: bundleManager.BundleInfo, bundleName: string): Promise<string> {
    let appLabel: string = '';
    try {
      if (!bundleInfo.appInfo) {
        return appLabel
      }
      if (bundleInfo.appInfo.labelId <= 0) {
        appLabel = bundleInfo.appInfo.label;
      } else {
        appLabel = GlobalContext.getContext().createBundleContext(bundleName)
          .resourceManager.getStringSync(bundleInfo.appInfo.labelId);
      }
      return appLabel;
    } catch (error) {
      log.showError(`getDeliverApplicationLabel fail: ${error?.code} ${error?.message}`);
    }
    return appLabel;
  }

  /**
   * 根据包名返回包label;
   *
   * @returns 包label
   */
  private async getDeliverBundleInfoLabel(bundleName: string): Promise<string> {
    try {
      const bundleInfo = await this.getDeliverBundleInfo(bundleName);
      if (bundleInfo === null) {
        return DEFAULT_BUNDLE_NAME;
      }
      let appLabel: string = await this.getDeliverApplicationLabel(bundleInfo, bundleName);
      if (appLabel === '') {
        return DEFAULT_BUNDLE_NAME;
      }
      log.showInfo('getDeliverBundleInfoLabel bundleName:%{public}s, appLabel:%{public}s', bundleName, appLabel);
      return appLabel;
    } catch (error) {
      log.showError(`getDeliverBundleInfoLabel fail: ${error?.code} ${error?.message}`);
    }
    return DEFAULT_BUNDLE_NAME;
  }

  public static getInstance(data?: PrivacySensorViewData): PrivacySensorViewModel {
    if (PrivacySensorViewModel.privacySensorViewModel === undefined) {
      PrivacySensorViewModel.privacySensorViewModel = new PrivacySensorViewModel();
    }
    if (data !== undefined) {
      PrivacySensorViewModel.privacySensorViewModel.viewData = data;
    }
    return PrivacySensorViewModel.privacySensorViewModel;
  }

  getPrivacySensorText(recentAppName: string): string {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      return '';
    }
    let privacyString = '';
    if (recentAppName === null || recentAppName === '') {
      return '';
    }
    if (this.viewData.privacySensorTypeArray.includes(ControlCenterPrivacyType.CAMERA.valueOf())) {
      privacyString =
        privacyString + ResUtils.getInnerString($r('app.string.cc_accessibility_str_privacy_string_camera'));
    }
    if (this.viewData.privacySensorTypeArray.includes(ControlCenterPrivacyType.MICROPHONE.valueOf())) {
      privacyString = privacyString + ResUtils.getInnerString($r('app.string.cc_accessibility_str_privacy_string_mic'));
    }
    if (this.viewData.privacySensorTypeArray.includes(ControlCenterPrivacyType.LOCATION.valueOf())) {
      privacyString =
        privacyString + ResUtils.getInnerString($r('app.string.cc_accessibility_str_privacy_string_location'));
    }
    if (!this.viewData.isOnlyAccessed) {
      return ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_privacy_report_string'), recentAppName, privacyString);
    }
    // 最近访问场景，单独处理文案
    let reportStr: string[] = ResUtils.getInnerString($r('app.string.cc_accessibility_str_privacy_report_string')).split('%2$s');
    if (reportStr.length !== 2) {
      return ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_privacy_report_string'), recentAppName, privacyString);
    }
    return recentAppName + ' ' + privacyString + ' ' + reportStr[1];
  }

  public getMultimediaSensorText(): string {
    if (this.viewData.multimediaSensorTypeArray[ControlCenterMultimediaType.BRACKET_KIT.valueOf()]) {
      return ResUtils.getInnerString($r('app.string.multimedia_sensor_bracket_kit'));
    } else if (this.viewData.multimediaSensorTypeArray[ControlCenterMultimediaType.SOUND_EFFECT.valueOf()]) {
      return ResUtils.getInnerString($r('app.string.multimedia_sensor_sound_effects'));
    } else if (this.viewData.multimediaSensorTypeArray[ControlCenterMultimediaType.VIDEO_EFFECT.valueOf()]) {
      return ResUtils.getInnerString($r('app.string.multimedia_sensor_video_effects'));
    }
    return '';
  }

  public getMultimediaSensorIconCount(): number {
    let count: number = this.viewData.multimediaSensorTypeArray.filter((item: boolean) => item).length;
    log.showWarn(`getMultimediaSensorIconCount: ${count}`);
    return count;
  }

  private updateTextMaxWidth(): void {
    if (this.viewData.multimediaSensorTypeArray.includes(true) && this.viewData.isApplicationInterview) {
      this.viewData.textMaxWidth = 49;
    } else {
      this.viewData.textMaxWidth = 129;
    }
  }

  private getIsShowText(): boolean {
    let privacySensorIconCount = this.viewData.privacySensorTypeArray.length;
    let multiMediaSensorIconCount = this.getMultimediaSensorIconCount();
    if (privacySensorIconCount === 0 || multiMediaSensorIconCount === 0) {
      return true;
    }
    return privacySensorIconCount <= 1 && multiMediaSensorIconCount <= 1;
  }

  public isTextOverflow(text: string, fontSize: number | string | Resource): boolean {
    return px2vp(MeasureText.measureText({
      textContent: text,
      fontSize: fontSize
    })) > this.viewData.textMaxWidth;
  }

  private updateGeometryTransitionId(): void {
    for (let i = 0; i < this.viewData.multimediaSensorTypeArray.length; i++) {
      if (this.viewData.multimediaSensorTypeArray[i]) {
        if (i === ControlCenterMultimediaType.BRACKET_KIT.valueOf()) {
          this.viewData.multimediaGeometryTransitionId = ['bracketKitCard', 'soundEffectCard', 'videoEffectCard'];
        } else if (i === ControlCenterMultimediaType.SOUND_EFFECT.valueOf()) {
          this.viewData.multimediaGeometryTransitionId = ['soundEffectCard', 'videoEffectCard', 'bracketKitCard'];
        } else if (i === ControlCenterMultimediaType.VIDEO_EFFECT.valueOf()) {
          this.viewData.multimediaGeometryTransitionId = ['videoEffectCard', 'bracketKitCard', 'soundEffectCard'];
        }
        return;
      }
    }
  }
}

export enum ControlCenterPrivacyType {
  CAMERA,
  MICROPHONE,
  LOCATION
}

export enum ControlCenterMultimediaType {
  BRACKET_KIT,
  SOUND_EFFECT,
  VIDEO_EFFECT
}
