/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import lazy { SCBTriFoldManager } from '@ohos/frameworkwrapper/src/main/ets/utils/SCBTriFoldManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import systemParameter from '@ohos.systemParameterEnhance';
import { systemParameterEnhance } from '@kit.BasicServicesKit';

// max incline thres
const MID_INCLINED_THRESHOLD_PHONE: number = 1 / 3;
const MID_INCLINED_THRESHOLD_ULTRA_SCREEN_FULL_EXPAND: number = 1 / 4;
const MID_INCLINED_THRESHOLD_PAD: number = 1 / 6;

// max divider number in midscene
const DIVIDER_MAX_NUM_PAD: number = 3;
const DIVIDER_MAX_NUM_PHONE: number = 2;

// max window size in midscene
const MIDSCENE_MAX_NUM_PHONE: number = 3;
const MIDSCENE_MAX_NUM_PAD: number = 4;

const TAG: string = 'MidSceneConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

interface IMidSceneConfig {
  margin: number;
  stepNum: number;
  leftRotateRatio: number;
  rightRotateRatio: number;
  gutter: number;
  dividerMaxNum: number;
  midSceneMaxNum: number;
  dividerHotArea: number[];
  midSceneToSplitDividerHotArea?: number[];
}

export class MidSceneConfigBase implements IMidSceneConfig {
  // 窗口和屏幕边框的距离
  public readonly margin: number = 40;
  // 中景最多支持档位数量，大折叠为small和large两个档位
  public readonly stepNum: number = 2;
  // 窗口向左旋转热区的比例
  public readonly leftRotateRatio: number = 1 / 3;
  // 窗口向右旋转热区的比例
  public readonly rightRotateRatio: number = 2 / 3;
  // 窗口和窗口之间的距离
  public readonly gutter: number = 12;
  // 分屏条最大数目
  public readonly dividerMaxNum = 2;
  // 中景窗口最大数目
  public readonly midSceneMaxNum = 3;
  // 分屏条end事件热区
  public readonly dividerHotArea: number[] = [1 / 5, 4 / 5];
  // 分屏条end事件热区（G态中景退分屏专用）
  public readonly midSceneToSplitDividerHotArea: number[] = [];
}

export class MidSceneConfig {
  private static isSupportPadDiff: boolean =
    systemParameter.getSync('persist.window.isSupportPadDiff', 'true') === 'true';
  private static midSceneMaxNumForPad: number | undefined;
  private static _isMidConfigSupport =
    systemParameterEnhance.getSync('const.window.supportMidScene', 'false') === 'true';
  private static isInclinedSnapshotSupport =
    systemParameterEnhance.getSync('persist.window.isSupportInclinedSnapshot', 'true') === 'true';
  // support size change app white list
  private static supportSizeChangeApps = [
    'com.app.xt.retouch',
    'com.lalamove.huolala.clienthar',
    'com.ifeng.news.ohos',
    'com.feeyo.variflight',
    'com.huayi.zshy',
  ];
  // unable to enter mid scene black list
  private static enterMidSceneBlackListPad: Set<string> = new Set([
    'com.meitu.beautycam',
    'com.htinns.application',
  ]);

  private static enterMidSceneBlackListPhone: Set<string> = new Set([
    'com.ohos.camera',
  ]);

  public static isSupportPadDifference(): boolean {
    return DeviceHelper.isPad() && this.isMidConfigSupport && MidSceneConfig.isSupportPadDiff;
  }

  public static get isMidConfigSupport(): boolean {
    return MidSceneConfig._isMidConfigSupport;
  }

  public static isSupportInclinedSnapshot(): boolean {
    return MidSceneConfig.isSupportPadDifference() && MidSceneConfig.isInclinedSnapshotSupport;
  }

  public static getMaxMidSceneNum() : number {
    if (!MidSceneConfig.isSupportPadDifference()) {
      return MIDSCENE_MAX_NUM_PHONE;
    }
    if (MidSceneConfig.midSceneMaxNumForPad === undefined) {
      let systemMidSceneNum: number | undefined = undefined;
      if (SCBWindowSceneConfig.getInstance().systemConfig) {
        systemMidSceneNum = SCBWindowSceneConfig.getInstance().systemConfig.maxMidSceneNum;
      }
      if (systemMidSceneNum !== MIDSCENE_MAX_NUM_PHONE &&
        systemMidSceneNum !== MIDSCENE_MAX_NUM_PAD) {
        log.showError(`midSceneMaxNum ${systemMidSceneNum} is invalid, should be 3 or 4!`);
        return MIDSCENE_MAX_NUM_PAD;
      }
      MidSceneConfig.midSceneMaxNumForPad = systemMidSceneNum;
    }
    return MidSceneConfig.midSceneMaxNumForPad;
  }

  public static getMaxDividerNum() : number {
    if (MidSceneConfig.isSupportPadDifference()) {
      return DIVIDER_MAX_NUM_PAD;
    }
    return DIVIDER_MAX_NUM_PHONE;
  }

  public static getMidInclinedThres() : number {
    if (MidSceneConfig.isSupportPadDifference()) {
      return MID_INCLINED_THRESHOLD_PAD;
    }
    if (SCBTriFoldManager.getInstance().isCurGState()) {
      return MID_INCLINED_THRESHOLD_ULTRA_SCREEN_FULL_EXPAND;
    }
    return MID_INCLINED_THRESHOLD_PHONE;
  }

  public static isSupportSizeChangeApp(bundleName: string): boolean {
    for (let app of this.supportSizeChangeApps) {
      if (bundleName === app) {
        log.showInfo(`isSupportSizeChangeApp support size change, bundleName: ${bundleName}`);
        return true;
      }
    }
    log.showInfo(`isSupportSizeChangeApp not support size change, bundleName: ${bundleName}`);
    return false;
  }

  public static isInEnterMidSceneBlackList(bundleName: string): boolean {
    let enterMidSceneBlackList: Set<string> =
      MidSceneConfig.isSupportPadDifference() ? MidSceneConfig.enterMidSceneBlackListPad :
      MidSceneConfig.enterMidSceneBlackListPhone;
    let isInBlackList: boolean = enterMidSceneBlackList.has(bundleName);
    log.showInfo(`isInEnterMidSceneBlackList: ${isInBlackList}, bundleName: ${bundleName}`);
    return isInBlackList;
  }
}