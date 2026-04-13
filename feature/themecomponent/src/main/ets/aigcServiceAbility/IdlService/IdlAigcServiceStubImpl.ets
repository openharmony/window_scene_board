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

import { effectKit } from '@kit.ArkGraphics2D';
import { JSON } from '@kit.ArkTS';
import {
  BusinessError,
  commonEventManager,
  emitter,
  systemDateTime,
} from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import type abilityCommon from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
// import AigcSdk from 'libaigceffect.so';
import {
  AigcConstant,
  GalleryCardLockConfig,
  HomeManifest,
  PandoraVideoConfig,
  VideoParameter
} from '../AigcConstant';
import { AigcFileUtils } from '../AigcFileUtils';
import { AigcHiSysEventUtil } from '../AigcHiSysEventUtil';
import AigcNotificationManager, { AigcNoticeType } from '../notificationmanager/AigcNotificationManager';
import { AigcPixelmapUtils } from '../AigcPixelmapUtils';
import { AIGCThemeInfoAdapter } from '../AIGCThemeInfoAdapter';
import { AigcWallpaperColorManager } from '../AigcWallpaperColorManager';
import { EditThemeArg } from '../TSCaller/EditThemeArg';
import { NullableType, ThemeInfoNew, ThemeOptions } from '../TSCaller/ThemeOptions';
import { TsRemoteCaller } from '../TSCaller/TsRemoteCaller';
import IIdlAigcExtServiceCallback from './callback/IIdlAigcExtServiceCallback';
import IdlAigcServiceStub from './IdlAigcServiceStub';
import { checkStateCallback, operateResult, resultStringCallback } from './IIdlAigcService';
import { SubScreenInfo } from './model/SubScreenInfo';
import INotificationConfig from '../notificationmanager/INotificationConfig';
import PandoraNotificationConfig from '../notificationmanager/PandoraNotificationConfig';
import { Log } from './Log';

const TAG = '[AigcService]IdlAigcServiceImpl';
const AIGC_VERSION: string = 'V2';
const DYNAMIC_VERSION: string = 'V3';
const AIGC_IMAGE: string = 'aigc.jpg';
const CONFIG_NAME: string = 'config.json';
const MS_TIME: number = 1000;

// 主题预置包中生成壁纸的数量
const PRESET_IMAGE_COUNT: number = 3;
const EXTREMELY_LIGHT_COLOR_PICTURE: number = 1;
// 主题画廊数据变更事件
const AOD_DIM_FACTOR: number = 90;
const ACTIVATE_AND_BEGIN_PANDORA_PARAM_COUNT: number = 6;
const COPY_DIR_OVERWRITE_MODE: number = 1;
const PANDORA2_NEW_NOTICE: string = 'PANDORA2_NEW_NOTICE';

export interface ThemeStatus {
  statusCode: number,
  errCode: number,
  internalStatus: number
}

export enum InternalStatus {
  INVALID = -1,
  VALID = 0,
  IDLE = 1,
}

export enum AigcStatus {
  AIGC_STATUS_FINISH = 0,
  AIGC_STATUS_ONGOING = 1,
  AIGC_STATUS_IDLE = 3
}

export enum AigcErrorCode {
  SUCC = 0,
  INVALID_ID = 10000,
  CLOUD_INPUT_ERROR = 10001,
  CLOUD_OUTPUT_ERROR = 10002,
  NOT_FOUND = 20000,
  FORCE_STOP = 20001,
}

export enum AigcCurrentThemeStatus {
  NO_PANDORA = 0,
  INNER_PANDORA = 1, // 内屏时空穿越，外屏其他主题
  OUTER_PANDORA = 2, // 外屏时空穿越，内屏其他
  FULL_PANDORA = 3, // 内外都是（但可能存在内外屏混搭不同时空穿越的情况）
}

export default class IdlAigcServiceImpl extends IdlAigcServiceStub {

  private static readonly SUCCESS: number = 0;

  private static readonly FAIL: number = 1;

  private static readonly INVALID: number = -1;

  private static readonly TERMINAL_DELAY: number = 30000;

  private context: abilityCommon.ServiceExtensionContext;

  private isInit: boolean = false;

  private static themeStateMap: Map<string, ThemeStatus> = new Map<string, ThemeStatus>();

  private static cbMap: Map<string, IIdlAigcExtServiceCallback> = new Map<string, IIdlAigcExtServiceCallback>();

  private static terminateSelfTimer: number = IdlAigcServiceImpl.INVALID;

  private static cachedThemeExternalCfg: string | null = null;

  private notificationConfig: INotificationConfig = new PandoraNotificationConfig();

  private isWaterMarkEnable: boolean = true;

  constructor(des: string, context: abilityCommon.ServiceExtensionContext) {
    super(des);
    this.context = context;
  }

  private waitAndTerminate(): void {
    if (IdlAigcServiceImpl.terminateSelfTimer !== IdlAigcServiceImpl.INVALID) {
      clearTimeout(IdlAigcServiceImpl.terminateSelfTimer);
    }
    this.setTerminateTimer();
  }

  private updateTerminateTimer(): void {
    if (IdlAigcServiceImpl.terminateSelfTimer !== IdlAigcServiceImpl.INVALID) {
      // Log.info(TAG, 'updateTerminateTimer clear timeout and reset timer');
      clearTimeout(IdlAigcServiceImpl.terminateSelfTimer);
      this.setTerminateTimer();
    }
  }

  private removeTerminateTimer(): void {
    if (IdlAigcServiceImpl.terminateSelfTimer !== IdlAigcServiceImpl.INVALID) {
      // Log.info(TAG, 'removeTerminateTimer clear timeout');
      clearTimeout(IdlAigcServiceImpl.terminateSelfTimer);
      IdlAigcServiceImpl.terminateSelfTimer = IdlAigcServiceImpl.INVALID;
    }
  }

  private setTerminateTimer(): void {
    // Log.info(TAG, 'setTerminateTimer set timeout');
    IdlAigcServiceImpl.terminateSelfTimer = setTimeout(() => {
      this.release();
      this.context.terminateSelf((err) => {
        // Log.warn(TAG, `terminateSelf finish`);
        IdlAigcServiceImpl.terminateSelfTimer = IdlAigcServiceImpl.INVALID;
      });
    }, IdlAigcServiceImpl.TERMINAL_DELAY);
  }

  public removeAIGC2PathList(toRemovePaths: string[], apply: boolean, themeId: string, needApply: boolean,
    callback: operateResult): void {
    // Log.info(TAG, `removeAIGC2PathList called apply: ${apply}`);
    try {
      if (this.needTerminate()) {
        this.waitAndTerminate();
      }
      toRemovePaths.forEach((toRemovePath: string) => {
        // AIGCThemeUtils.removeFileOrDir(toRemovePath);
      })
      if (apply) {
        // AIGCThemeUtils.activateThemeByCarousel(themeId, needApply).then((res: boolean) => {
        //   callback(res ? IdlAigcServiceImpl.SUCCESS : IdlAigcServiceImpl.FAIL);
        // })
      } else {
        callback(IdlAigcServiceImpl.SUCCESS);
      }
    } catch (err) {
      // Log.error(TAG, `removeThemeDir remove failed msg. Code is ${err?.code}, message is ${err?.message}`);
      callback(IdlAigcServiceImpl.FAIL);
    }
  }

  private checkGenerateImagesValid(themeID: string, algParam: string): boolean {
    return themeID.length > 0 && algParam.length > 0;
  }

  public async generateImages(themeID: string, url: string, algParam: string,
    callback: resultStringCallback): Promise<void> {
    // Log.info(TAG, `generateImages called`);
    if (!this.checkGenerateImagesValid(themeID, algParam)) {
      // Log.error(TAG, `generateImages input param is invald`);
      callback(IdlAigcServiceImpl.FAIL, 'generateImages internal error: input param is invald');
      return;
    }
    this.removeTerminateTimer();

    // const themeConfigPath: string = `${PandoraUtils.getConfigDir()}/${themeID}`;
    // let configJson: PandoraConfig | undefined = this.getPandoraConfig(themeConfigPath);
    // if (configJson === undefined) {
    //   Log.error(TAG, 'generateImages: getConfigContent fail');
      callback(IdlAigcServiceImpl.FAIL, 'generateImages internal error: getConfigContent fail');
      return;
    // }
    // configJson.status = AIGCEditorStatus.FIRST_GENERATE_AI;
    // let fileSaveRes: boolean =
    //   await AigcFileUtils.createFileWithJsonObject(`${themeConfigPath}/${CONFIG_NAME}`, configJson);
    // if (!fileSaveRes) {
    //   Log.error(TAG, 'generateImages: save config fail');
    //   callback(IdlAigcServiceImpl.FAIL, 'generateImages internal error: save config fail');
    //   return;
    // }
    //
    // let inputPixmap: image.PixelMap | undefined = AigcPixelmapUtils.loadPixelMap(url);
    // if (inputPixmap === undefined) {
    //   Log.error(TAG, `generateImages: load pixelmap failed.`);
    //   callback(IdlAigcServiceImpl.FAIL, 'generateImages internal error: load pixelmap error');
    //   return;
    // }
    // IdlAigcServiceImpl.themeStateMap.set(themeID, { errCode: 0,
    //   statusCode: AigcStatus.AIGC_STATUS_ONGOING, internalStatus: InternalStatus.IDLE});
    // const startTime: number = new Date().getTime();
    // PandoraUtils.generateImages(themeID, inputPixmap, algParam, this.context).then(async (errorCode: number) => {
    //   AigcHiSysEventUtil.reportPandoraImageActive(new Date().getTime() - startTime, errorCode === 0);
    //   await this.generateImagesCallback(errorCode, themeID);
    // }).catch((err: number) => {
    //   callback(err, 'generateImages failed.');
    // });
    // callback(IdlAigcServiceImpl.SUCCESS, 'generateImages success.');
  }

  public checkState(themeId: string, callback: resultStringCallback): void {
    // Log.info(TAG, 'checkState called');
    try {
      this.updateTerminateTimer();
      if (!this.isInit) {
        this.init();
        this.isInit = true;
      }
      // AigcSdk.checkAigcImageStatus(themeId);
      callback(IdlAigcServiceImpl.SUCCESS, 'checkState success.');
    } catch (err) {
      callback(IdlAigcServiceImpl.FAIL, 'checkState failed.');
    }
  }

  public register(key: string, cb: IIdlAigcExtServiceCallback, callback: operateResult): void {
    // Log.info(TAG, 'register called');
    this.updateTerminateTimer();
    IdlAigcServiceImpl.cbMap.set(key, cb);
    callback(IdlAigcServiceImpl.SUCCESS);
  }

  public unRegister(key: string, callback: operateResult): void {
    // Log.info(TAG, 'unRegister called');
    this.updateTerminateTimer();
    if (IdlAigcServiceImpl.cbMap.has(key)) {
      IdlAigcServiceImpl.cbMap.delete(key);
      // Log.info(TAG, 'unRegister res: unregister success', key);
      callback(IdlAigcServiceImpl.SUCCESS);
    } else {
      // Log.warn(TAG, 'unRegister res: not registered', key);
      callback(IdlAigcServiceImpl.FAIL);
    }
  }

  public checkStateSync(themeId: string, callback: checkStateCallback): void {
    // Log.info(TAG, 'checkStateSync called');
    try {
      let isAigc2Theme: boolean = this.isAigc2Theme(themeId);
      if (!isAigc2Theme) {
        this.updateTerminateTimer();
      }
      if (!this.isInit) {
        this.init();
        this.isInit = true;
      }
      let themeStatus: ThemeStatus | undefined = IdlAigcServiceImpl.themeStateMap.get(themeId);
      if (themeStatus !== undefined) {
        // Log.info(TAG, 'checkStateSync theme state exists');
        callback(IdlAigcServiceImpl.SUCCESS, themeStatus.statusCode, themeStatus.errCode);
      } else {
        // Log.info(TAG, 'checkStateSync theme state not exists, call AigcEffect');
        if (isAigc2Theme) {
          this.updateTerminateTimer();
        }
        callback(IdlAigcServiceImpl.SUCCESS, IdlAigcServiceImpl.INVALID, AigcErrorCode.NOT_FOUND);
      }
    } catch (err) {
      callback(IdlAigcServiceImpl.FAIL, IdlAigcServiceImpl.INVALID, IdlAigcServiceImpl.INVALID);
    }
  }

  private isAigc2Theme(themeID: string): boolean {
    // return FileUtil.isFileExists(`${AIGCUtils.getConfigDir()}${themeID}/${AIGC_IMAGE}`);
    return false
  }

  public removePathList(toRemovePaths: string[], apply: boolean, themeId: string, isEnableNotify: boolean,
    callback: operateResult): void {
    // Log.info(TAG, `removeThemeDir called apply: ${apply}`);
    try {
      this.updateTerminateTimer();
      toRemovePaths.forEach((toRemovePath: string) => {
        this.removeFileOrDir(toRemovePath);
      })
      if (apply) {
        this.activateThemeByCarousel(themeId, true).then((res: boolean) => {
          callback(res ? IdlAigcServiceImpl.SUCCESS : IdlAigcServiceImpl.FAIL);
        })
      } else {
        callback(IdlAigcServiceImpl.SUCCESS);
      }
    } catch (err) {
      // Log.error(TAG, `removeThemeDir remove failed msg. Code is ${err?.code}, message is ${err?.message}`);
      callback(IdlAigcServiceImpl.FAIL);
    }
  }

  public dealWithPandoraNotify(themeId: string, notifyType: number, errCode: number, callback: operateResult,
    version: string): void {
    // Log.info(TAG, `dealWithPandoraNotify called themeId: ${themeId}, notifyType: ${notifyType}, errCode: ${errCode}`);
    try {
      switch (notifyType) {
        case AigcNotificationManager.STATUS_ONGOING:
          AigcNotificationManager.getInstance().sendNotice(themeId, AigcNoticeType.EXECUTING,
            this.notificationConfig, errCode, version);
          IdlAigcServiceImpl.themeStateMap.set(themeId, {errCode: errCode, statusCode: AigcStatus.AIGC_STATUS_ONGOING,
            internalStatus: InternalStatus.IDLE});
          if (version === AIGC_VERSION) {
            emitter.emit(PANDORA2_NEW_NOTICE, {data: {
              'themeId': themeId
            }});
          }
          callback(IdlAigcServiceImpl.SUCCESS);
          break;
        case AigcNotificationManager.STATUS_FAIL:
          AigcNotificationManager.getInstance().sendNotice(themeId, AigcNoticeType.FAIL,
            this.notificationConfig, errCode, version);
          IdlAigcServiceImpl.themeStateMap.set(themeId, {errCode: errCode, statusCode: AigcStatus.AIGC_STATUS_FINISH,
            internalStatus: InternalStatus.VALID});
          callback(IdlAigcServiceImpl.SUCCESS);
          break;
        case AigcNotificationManager.STATUS_CANCEL:
          IdlAigcServiceImpl.themeStateMap.set(themeId, {errCode: errCode, statusCode: AigcStatus.AIGC_STATUS_FINISH,
            internalStatus: InternalStatus.INVALID});
          AigcNotificationManager.getInstance().cancelNotifyByEditorId(themeId, this.notificationConfig);
          callback(IdlAigcServiceImpl.SUCCESS);
          break;
        default:
          // Log.warn(TAG, `dealWithPandoraNotify fail: not supported notify type`);
          callback(IdlAigcServiceImpl.FAIL);
      }
    } catch (err) {
      // Log.error(TAG, `dealWithPandoraNotify fail. Code is ${err?.code}, message is ${err?.message}`);
      callback(IdlAigcServiceImpl.FAIL);
    }
  }

  public async activateAndGenerateImages(paramList: string[], callback: operateResult): Promise<void> {
    // Log.info(TAG, 'activateAndGenerateImage called');
    if (paramList.length !== 3) {
      // Log.error(TAG, 'activateAndGenerateImage input paramList wrong');
      callback(IdlAigcServiceImpl.FAIL);
      return;
    }
    const presetPath: string = paramList[0];
    const taskTimeStamp: string = paramList[1];
    // const sandBoxPath: string = PandoraUtils.getConfigDir();
    //
    // const taskConfigPath: string = `${sandBoxPath}/needActivateThemes/${taskTimeStamp}`;
    // let configJson: PandoraConfig | undefined = this.getPandoraConfig(taskConfigPath);
    // if (configJson === undefined) {
    //   Log.error(TAG, 'activateAndGenerateImages getConfigContent fail');
      callback(IdlAigcServiceImpl.FAIL);
      return;
    // }
    // const customPath: string = `${sandBoxPath}/${PandoraConstants.TMP_DIR}`;
    // try {
    //   const themeID: string = await this.activateNewTheme(presetPath, customPath,
    //     this.typeScreenConversion(configJson?.isApplyToMain), this.typeScreenConversion(configJson?.isApplyToCover));
    //   if (themeID.length === 0) {
    //     Log.error(TAG, 'activateAndGenerateImages activate fail');
    //     callback(IdlAigcServiceImpl.FAIL);
    //     return;
    //   }
    //   const themeConfigPath: string = `${sandBoxPath}${themeID}`;
    //   let res: boolean = await this.refactorConfig(taskConfigPath, themeConfigPath, configJson);
    //   if (!res) {
    //     Log.error(TAG, 'activateAndGenerateImages refactorConfig fail');
    //     callback(IdlAigcServiceImpl.FAIL);
    //     return;
    //   }
    //   Log.info(TAG, 'activateAndGenerateImages refactorConfig success');
    //   // 上云生成
    //   const algParam: string = paramList[2];
    //   const uploadImageUri: string = configJson.url;
    //   this.generateImages(themeID, uploadImageUri, algParam, (errCode: number, retVal: string): void => {
    //     if (errCode === IdlAigcServiceImpl.FAIL) {
    //       Log.error(TAG, `activateAndGenerateImages call generateImages fail, Error: ${retVal}`);
    //       callback(IdlAigcServiceImpl.FAIL);
    //       return;
    //     }
    //     AigcNotificationManager.getInstance().sendNotice(themeID, AigcNoticeType.EXECUTING, this.notificationConfig);
    //     callback(IdlAigcServiceImpl.SUCCESS);
    //   })
    // } catch (error) {
    //   // Log.error(TAG, `activateAndGenerateImages Error: ${error?.code}, ${error?.message}`);
    //   callback(IdlAigcServiceImpl.FAIL);
    // }
  }

  public async activateAndGenerateVideo(paramList: string[], callback: resultStringCallback): Promise<void> {
    // Log.info(TAG, 'activateAndGenerateVideo called');
    this.removeTerminateTimer()
    const presetPath: string = paramList[0];
    const originImgDir: string = paramList[1];
    const type: string = paramList[2];
    const style: string = paramList[3];
    let themeID: string = paramList[4];
    // Log.info(TAG, `type is ${type}, style is ${style}, current themeID = ${themeID}`);
    const toActivatePath: string = `${AigcConstant.CAROUSEL_DIR}/temp_${systemDateTime.getTime()}`;
    let retCode: boolean = false;
    try {
      const originImgTmpPath: string = `${originImgDir}/origin.jpg`;
      if (!await AIGCThemeInfoAdapter.prepareOriThemeRsc(originImgTmpPath, toActivatePath)) {
        // Log.error(TAG, `activateAndGenerateVideo prepareOriThemeRsc failed.`);
        callback(IdlAigcServiceImpl.FAIL, '');
        return;
      }
      if (themeID !== '') { // 更新照片
        fs.rmdirSync(`${AigcConstant.CAROUSEL_DIR}/${themeID}`);
        let arg: EditThemeArg = new EditThemeArg(themeID, 'Pandora');
        arg.customPath = toActivatePath;
        arg.activate = false;
        arg.isUsable = false;
        await TsRemoteCaller.getInstance(this.context).editTheme(arg);
      } else { // 首次上传
        // themeID = await AIGCThemeUtils.activateNewTheme(presetPath, toActivatePath);
        if (themeID === '') {
          // Log.error(TAG, `activateAndGenerateVideo create a new theme failed.`);
          callback(IdlAigcServiceImpl.FAIL, '');
          return;
        }
        // Log.info(TAG, `activateAndGenerateVideo create a new theme successfully, themeID is ${themeID}`);
      }
      const themeRscPath: string = `${AigcConstant.CAROUSEL_DIR}/${themeID}`;
      fs.mkdirSync(themeRscPath, true);
      // 记录用户选择的原图
      fs.moveFileSync(originImgTmpPath, `${themeRscPath}/origin.jpg`);
      // 记录用户选择的风格、性别
      let config: PandoraVideoConfig = new PandoraVideoConfig();
      config.style = style;
      config.type = type;
      // retCode = await FileUtil.createFileWithJsonObject(`${themeRscPath}/params.json`, config);
      if (!retCode) {
        // Log.error(TAG, `activateAndGenerateVideo create params file failed.`);
        callback(IdlAigcServiceImpl.FAIL, themeID);
        return;
      }
    } catch (error) {
      // Log.error(TAG, `activateAndGenerateVideo Error: ${error?.code}, ${error?.message}`);
      callback(IdlAigcServiceImpl.FAIL, themeID);
      return;
    } finally {
      if (!retCode && this.needTerminate()) {
        this.waitAndTerminate();
      }
      try {
        fs.rmdirSync(toActivatePath);
      } catch (error) {
        // Log.error(TAG, `activateAndGenerateVideo remove toActivatePath failed: ${error?.code}, ${error?.message}`);
      }
    }
    let aigcParam: VideoParameter = {
      scenario: '',
      style: AigcFileUtils.randomStyle(type, style),
      type: type,
      // watermark: DynamicUtils.getWatermarkStatus(),
      watermark: false,
      // demander: DeviceHelper.isFoldButNotSmallFoldProduct() ? AigcConstant.DEVICE_TYPE_LARGE_FOLD :
      //   AigcConstant.DEVICE_TYPE_STRAIGHT,
      demander: AigcConstant.DEVICE_TYPE_STRAIGHT,
      generateNum: AigcConstant.GENERATE_VIDEO_COUNT
    };
    this.generateVideo(aigcParam, themeID, (errCode: number, retVal: string): void => {
      if (errCode === IdlAigcServiceImpl.FAIL) {
        // Log.error(TAG, `activateAndGenerateVideo call generateVideo failed, Error: ${retVal}`);
        callback(IdlAigcServiceImpl.FAIL, themeID);
        return;
      }
      AigcNotificationManager.getInstance().sendNotice(themeID, AigcNoticeType.EXECUTING, this.notificationConfig, 0,
        DYNAMIC_VERSION);
      callback(IdlAigcServiceImpl.SUCCESS, themeID);
    });
  }

  public async updateVideo(scenario: string, themeID: string): Promise<void> {
    this.removeTerminateTimer();
    const isScenarioUpdate: boolean = themeID === '';
    if (themeID === '') {
      let currentTheme: NullableType<ThemeInfoNew> = await TsRemoteCaller.getInstance(this.context).getCurrentTheme();
      themeID = currentTheme?.editorId ?? '';
      // Log.info(TAG, `updateVideo by scenario update, current theme is ${themeID}.`);
      if (themeID === '') {
        // Log.error(TAG, 'updateVideo failed: cannot get current theme info');
        if (this.needTerminate()) {
          this.waitAndTerminate();
        }
        return;
      }
    } else {
      // Log.info(TAG, `updateVideo by continue generate, current theme is ${themeID}.`);
    }
    const existingVideoCnt: number = AigcFileUtils.listDirSync(`${AigcConstant.CAROUSEL_DIR}/${themeID}`).length;
    // Log.info(TAG, `updateVideo existingVideoCnt is ${existingVideoCnt}`);
    const videoThemeConfig: PandoraVideoConfig | undefined =
      AigcFileUtils.getPandoraVideoConfig(`${AigcConstant.CAROUSEL_DIR}/${themeID}/params.json`);
    if (videoThemeConfig === undefined || (isScenarioUpdate && !videoThemeConfig.enableUpdate) || // 情境更新开关关闭
      existingVideoCnt >= AigcConstant.MAX_VIDEO_COUNT ) { // 已生成的资源数量已达上限
      // Log.error(TAG, `updateVideo failed: cannot get config ${JSON.stringify(videoThemeConfig)}`);
      if (this.needTerminate()) {
        this.waitAndTerminate();
      }
      return;
    }

    let needGenerateCnt: number = AigcConstant.GENERATE_VIDEO_COUNT;
    if (AigcConstant.MAX_VIDEO_COUNT - existingVideoCnt < AigcConstant.GENERATE_VIDEO_COUNT) {
      needGenerateCnt = AigcConstant.MAX_VIDEO_COUNT - existingVideoCnt;
    }
    const aigcParam: VideoParameter = {
      scenario: '',
      style: AigcFileUtils.randomStyle(videoThemeConfig.type, videoThemeConfig.style),
      type: videoThemeConfig.type,
      // watermark: DynamicUtils.getWatermarkStatus(),
      // templateIdList: AigcFileUtils.parseExistingTemplate(videoThemeConfig.templateIdList!),
      // demander: DeviceHelper.isFoldButNotSmallFoldProduct() ? AigcConstant.DEVICE_TYPE_LARGE_FOLD :
      //   AigcConstant.DEVICE_TYPE_STRAIGHT,
      watermark: true,
      templateIdList: AigcFileUtils.parseExistingTemplate(videoThemeConfig.templateIdList!),
      demander: AigcConstant.DEVICE_TYPE_STRAIGHT,
      generateNum: needGenerateCnt
    };
    this.generateVideo(aigcParam, themeID, (errCode: number, retVal: string): void => {
      if (errCode === IdlAigcServiceImpl.FAIL) {
        // Log.error(TAG, `updateVideo call generateVideo failed. Code: ${errCode}, message: ${retVal}`);
        return;
      }
      AigcNotificationManager.getInstance().sendNotice(themeID, AigcNoticeType.EXECUTING, this.notificationConfig, 0,
        DYNAMIC_VERSION);
    })
  }

  private async generateVideo(aigcParam: VideoParameter, themeID: string,
    callback: resultStringCallback): Promise<boolean> {
    let timeStamp: number = new Date().getTime();
    const downloadPath: string = `${AigcConstant.CAROUSEL_DIR}/${themeID}/${timeStamp}`;
    try {
      const themeRscPath: string = `${AigcConstant.CAROUSEL_DIR}/${themeID}`;
      let pixmap: image.PixelMap | undefined = AigcPixelmapUtils.loadPixelMap(`${themeRscPath}/origin.jpg`);
      if (pixmap === undefined) {
        // Log.error(TAG, 'generateVideo: original pixelmap is undefined');
        callback(IdlAigcServiceImpl.FAIL, 'generateVideo internal error: original pixelmap is undefined');
        return false;
      }
      // 记录开始生成的状态
      // if (!await AigcFileUtils.recordTaskConfig(AIGCEditorStatus.FIRST_GENERATE_AI, 0,
      //   `${themeRscPath}/task_config.json`)) {
        // Log.error(TAG, `generateVideo: create task config failed.`);
      //   callback(IdlAigcServiceImpl.FAIL, 'generateVideo internal error: create task config failed.');
      //   return false;
      // }
      IdlAigcServiceImpl.themeStateMap.set(themeID, { errCode: 0,
        statusCode: AigcStatus.AIGC_STATUS_ONGOING, internalStatus: InternalStatus.IDLE});
      callback(IdlAigcServiceImpl.SUCCESS, 'generateVideo: call generateVideo success.');
      // let errCode: number = await DynamicUtils.generateVideo(downloadPath, JSON.stringify(aigcParam), pixmap);
      let errCode: number = 0;
      if (errCode === 0) {
        await AigcPixelmapUtils.dimForVideo(themeRscPath, timeStamp.toString());
        if (!await AIGCThemeInfoAdapter.activateVideoTheme(this.context, themeID)) {
          // Log.error(TAG, `generateVideo activateVideoTheme failed for ${themeID}.`);
        }
      }
      // 记录生成完成的状态
      AigcNotificationManager.getInstance().sendNotice(themeID,
        errCode === 0 ? AigcNoticeType.FINISH : AigcNoticeType.FAIL, this.notificationConfig, errCode, DYNAMIC_VERSION);
      IdlAigcServiceImpl.themeStateMap.set(themeID,
        { errCode: errCode, statusCode: AigcStatus.AIGC_STATUS_FINISH, internalStatus: InternalStatus.IDLE });
      // await AigcFileUtils.recordTaskConfig(errCode === 0 ? AIGCEditorStatus.FIRST_GENERATE_AI_SUCCESS :
      //   AIGCEditorStatus.FIRST_GENERATE_AI_FAILED, errCode, `${themeRscPath}/task_config.json`);
      commonEventManager.publish(AigcConstant.AIGC_VIDEO_GENERATE_FINISHED, {
        data: themeID,
        parameters: { errorCode: errCode }
      }, this.onPublish);
      return true;
    } catch (err) {
      // Log.error(TAG, `release failed. Code is ${err?.code}, message is ${err?.message}`);
      return false;
    } finally {
      if (this.needTerminate()) {
        this.waitAndTerminate();
      }
    }
  }

  private removeFileOrDir(toRemovePath: string): void {
    if (!toRemovePath.startsWith(AigcConstant.CAROUSEL_DIR)) {
      // Log.error(TAG, 'toRemovePath is not carousel dir, cannot remove it');
      return;
    }
    if (fs.accessSync(toRemovePath)) {
      if (fs.lstatSync(toRemovePath).isDirectory()) {
        fs.rmdirSync(toRemovePath);
        // Log.info(TAG, `remove carousel dir success`);
      } else {
        fs.unlinkSync(toRemovePath);
        const toRemoveAodPath: string = toRemovePath.replace('unlock', 'aod');
        if (fs.accessSync(toRemoveAodPath)) {
          fs.unlinkSync(toRemoveAodPath);
        }
        // Log.info(TAG, `remove unlock and aod file in carousel dir success`);
      }
    } else {
      // Log.warn(TAG, `remove path fail`);
    }
  }

  private release(): void {
    // Log.info(TAG, 'cbMap clear');
    IdlAigcServiceImpl.cbMap.clear();
    this.isInit = false;
    try {
      // AigcSdk.destroyAigcEffect();
      // Log.info(TAG, `release success`);
    } catch (err) {
      // Log.error(TAG, `release failed. Code is ${err?.code}, message is ${err?.message}`);
    }
  }

  private init() {
    try {
      this.initDir();
      // Log.info(TAG, `init finish`);
    } catch (err) {
      // Log.error(TAG, `init failed. Code is ${err?.code}, message is ${err?.message}`);
    }
  }

  private initDir() {
    try {
      if (!fs.accessSync(AigcConstant.DOWNLOAD_DIR)) {
        fs.mkdirSync(AigcConstant.DOWNLOAD_DIR, true);
        // Log.info(TAG, 'initDir init download dir finish');
      }
      // if (!fs.accessSync(AIGCConstants.SAVED_PIC_DIR)) {
      //   fs.mkdirSync(AIGCConstants.SAVED_PIC_DIR, true);
      //   Log.info(TAG, 'initDir init download dir finish');
      // }
    } catch (err) {
      // Log.error(TAG, `initDir failed. Code is ${err?.code}, message is ${err?.message}`);
    }
  }

  private async preparePicFromDownloadToCarousel(themeId: string): Promise<boolean> {
    try {
      // Log.info(TAG, `prepareWpFromDownloadToCarousel start.`)
      let themeDownloadDir = ''
        // AIGCConstants.SAVED_PIC_DIR;
      // let themeCarouselDir: string = AIGCConstants.THEME_PIC_DIR + '/' + themeId;
      let themeCarouselDir: string =  '/' + themeId;
      // Log.info(TAG, `themeDownloadDir` + themeDownloadDir + ' themeCarouselDir ' + themeCarouselDir);
      let fileNames: string[] = fs.listFileSync(themeDownloadDir).sort();
      if (!fs.accessSync(themeCarouselDir)) {
        // Log.info(TAG, `prepareWpFromDownloadToCarousel CAROUSEL_DIR not exist, mkdir ${themeCarouselDir}`);
        fs.mkdirSync(themeCarouselDir, true);
      }
      let existFilesCount: number = fs.listFileSync(themeCarouselDir, {
        filter: {
          displayName: ['unlock_wallpaper_*.jpg']
        }
      }).length;
      let copyFileCount: number = Math.min(fileNames.length, AigcConstant.MAX_FILE_COUNT - existFilesCount);
      for (let i: number = 0; i < copyFileCount; i++) {
        let currFile: string = themeDownloadDir + '/' + fileNames[i];
        let curCarouselFileName: string = `/unlock_wallpaper_${new Date().getTime()}_${i + 1}.jpg`;
        let destFile: string = themeCarouselDir + curCarouselFileName;
        const dimFile: string = curCarouselFileName.replace('unlock', 'aod');
        // Log.info(TAG, `copyAndDimFiles start copy ${fileNames[i]} to ${curCarouselFileName} and dim to ${dimFile}`);
        await this.copyAndDimFiles(currFile, destFile, themeCarouselDir + dimFile, AigcConstant.WATER_MARK_X_V2,
          AigcConstant.WATER_MARK_Y_V2);
      }
      // Log.info(TAG, `prepareWpFromDownloadToCarousel finish.`);
      return true;
    } catch (err) {
      // Log.error(TAG, `prepareWpFromDownloadToCarousel error. Code is ${err?.code}, message is ${err?.message}`);
      return false;
    }
  }

  private checkGeneratePicturesValid(themeId: string, url: string): boolean {
    return themeId.length > 0 && url.length > 0;
  }

  /**
   * 使能、创建配置文件并且开始生成
   *
   * @param paramList 结构为[预制包路径, 沙箱路径, 配置文件夹相对路径, uid, token, algParam]
   * @param callback 端侧回调
   */
  public startGeneratePandora(paramList: string[], callback: resultStringCallback): void {
    // Log.info(TAG, `startGeneratePandora paramList count ${paramList.length}`);
    this.removeTerminateTimer();
    this.activateAndBeginPandora2Async(paramList, callback);
  }

  private async activateAndBeginPandora2Async(paramList: string[], callback: resultStringCallback): Promise<void> {
    if (paramList.length !== 2) {
      // Log.error(TAG, 'activateAndBeginPandora param number wrong');
      callback(IdlAigcServiceImpl.FAIL, '');
      return;
    }
    if (!this.isInit) {
      this.init();
      this.isInit = true;
    }
    const presetPath: string = paramList[0];
    const themeID: string = paramList[1];
    // const sandBoxUri: string = AIGCUtils.getConfigDir();
    // Log.info(TAG, `themeID ${themeID} sandBoxUri ${sandBoxUri}`);
    try {
      // const themeId: string = await AIGCThemeUtils.activateNewTheme(presetPath, AIGCConstants.TEMP_DIR);
      // const themeConfigDir: string = `${sandBoxUri}${themeId}`;
      // if (themeId.length === 0) {
      //   Log.error(TAG, 'activateAndBeginPandora activate fail');
        callback(IdlAigcServiceImpl.FAIL, '');
        // await FileUtil.removeDirectoryRecursively(AIGCConstants.TEMP_DIR);
        // await FileUtil.removeDirectoryRecursively(`${sandBoxUri}${themeID}`);
        return;
      // }
      // await FileUtil.rename(`${sandBoxUri}${themeID}`, themeConfigDir);
      // Log.info(TAG, `rename finished, themeConfigDirPath themeConfigDirPath ${themeConfigDir}`);
      // let configJson: AIGCConfig | undefined = AIGCThemeUtils.getPandoraConfig(themeConfigDir);
      // if (configJson === undefined) {
      //   Log.error(TAG, 'activateAndBeginPandora getConfigContent fail');
      //   callback(IdlAigcServiceImpl.FAIL, '');
      //   return;
      // }
      // await this.generatePics(configJson, themeId, themeConfigDir, callback);
    } catch (error) {
      // Log.error(TAG, `activateAndBeginPandora Error: ${error?.code}, ${error?.message}`);
      callback(IdlAigcServiceImpl.FAIL, '');
    }
  }

  // private async generatePics(configJson: AIGCConfig, themeId: string, themeConfigDirPath: string,
  //   callback: resultStringCallback): Promise<void> {
    // configJson.status = AIGCEditorStatus.FIRST_GENERATE_AI;
    // AigcNotificationManager.getInstance().sendNotice(themeId, AigcNoticeType.EXECUTING,
    //   this.notificationConfig, 0, AIGC_VERSION);
    // emitter.emit(PANDORA2_NEW_NOTICE, {data: {
    //   'themeId': themeId
    // }});
    // IdlAigcServiceImpl.themeStateMap.set(themeId, { errCode: 0,
    //   statusCode: AigcStatus.AIGC_STATUS_ONGOING, internalStatus: InternalStatus.IDLE});
    // await AigcFileUtils.createFileWithJsonObject(`${themeConfigDirPath}/${CONFIG_NAME}`, configJson);
    // callback(IdlAigcServiceImpl.SUCCESS, themeId);
    // Log.info(TAG, 'start to create pics.');
    // const startTime: number = systemDateTime.getTime(false);
    // let errorCode: number = await AIGCUtils.createAIPixelMap(configJson, `${themeConfigDirPath}/${AIGC_IMAGE}`);
    // Log.info(TAG, `generate pics code: ${errorCode}`);
    // const endTime: number = systemDateTime.getTime(false);
    // AIGCHiSysEventUtil.reportAigcResult(errorCode === 0, errorCode, (endTime - startTime) / MS_TIME);
    // configJson.status = errorCode === 0 ? AIGCEditorStatus.FIRST_GENERATE_AI_SUCCESS :
    //   AIGCEditorStatus.FIRST_GENERATE_AI_FAILED;
    // configJson.notifyErrCode = errorCode;
    // await AigcFileUtils.createFileWithJsonObject(`${themeConfigDirPath}/${CONFIG_NAME}`, configJson);
    // this.generateCallback(themeId, errorCode, true);
  // }

  public async generatePictures(themeId: string, url: string, callback: resultStringCallback): Promise<void> {
    // Log.info(TAG, 'generatePictures called');
    if (!this.checkGeneratePicturesValid(themeId, url)) {
      // Log.error(TAG, `generatePictures input param is invald`);
      callback(IdlAigcServiceImpl.FAIL, 'generatePictures error.');
      // 发送失败消息
      return;
    }
    this.removeTerminateTimer();
    IdlAigcServiceImpl.themeStateMap.delete(themeId);
    try {
      if (!this.isInit) {
        this.init();
        this.isInit = true;
      }
      // let configJson: AIGCConfig | undefined = AIGCThemeUtils.getPandoraConfig(url.replace(`/${AIGC_IMAGE}`, ''));
      // if (!configJson) {
      //   Log.error(TAG, 'error Json.');
      //   return;
      // }
      // configJson.status = AIGCEditorStatus.GENERATE_AI_AGAIN;
      // await AigcFileUtils.createFileWithJsonObject(url.replace(AIGC_IMAGE, CONFIG_NAME), configJson);
      // Log.info(TAG, `start to regenerate pics configStyle = ${configJson.style}`);
      // callback(IdlAigcServiceImpl.SUCCESS, 'requestImage success.');
      // const startTime: number = systemDateTime.getTime(false);
      // await AIGCUtils.createAIPixelMap(configJson, url)
      //   .then(async (errorCode: number) => {
      //     Log.info(TAG, `regenerate pics: ${errorCode}`);
      //     if (!configJson) {
      //       Log.error(TAG, 'error json.');
      //       return;
      //     }
      //     if (errorCode === 0) {
      //       configJson.status = AIGCEditorStatus.GENERATE_AI_AGAIN_SUCCESS;
      //     } else {
      //       configJson.status = AIGCEditorStatus.GENERATE_AI_AGAIN_FAILED;
      //     }
      //     configJson.notifyErrCode = errorCode;
      //     const endTime: number = systemDateTime.getTime(false);
      //     AIGCHiSysEventUtil.reportAigcResult(errorCode === 0, errorCode, (endTime - startTime) / MS_TIME);
      //     await AigcFileUtils.createFileWithJsonObject(url.replace(AIGC_IMAGE, CONFIG_NAME), configJson);
      //     this.generateCallback(themeId, errorCode, true);
      //   });
    } catch (err) {
      // Log.info(TAG, `server end catch error. Code is ${err?.code}, message is ${err?.message}`);
      callback(IdlAigcServiceImpl.FAIL, 'requestImage error.');
    }
  }

  private async generateCallback(themeId: string, errorCode: number, isFirst: boolean = false): Promise<void> {
    // Log.info(TAG, 'AI image finished.')
    if (errorCode === 0) {
      // Log.info(TAG, `AI image success.`);
      // let savedThemeDir: string = AIGCConstants.SAVED_PIC_DIR;
      let savedThemeDir: string = '';
      if (!fs.accessSync(savedThemeDir)) {
        // Log.error(TAG, `download dictionary not exists.`);
      } else {
        try {
          // this.isWaterMarkEnable = DynamicUtils.getWatermarkStatus();
          await this.preparePicFromDownloadToCarousel(themeId);
          // await AIGCThemeUtils.activateThemeByCarousel(themeId, false);
          // FileUtil.clearDirectory(savedThemeDir);
        } catch (e) {
          // Log.error(TAG, 'activateTheme error');
        }
      }
      AigcNotificationManager.getInstance().sendNotice(themeId, AigcNoticeType.FINISH,
        this.notificationConfig, 0, AIGC_VERSION);
    } else {
      // Log.error(TAG, `AI image failed.`);
      // 任务失败通知
      AigcNotificationManager.getInstance().sendNotice(themeId, AigcNoticeType.FAIL,
        this.notificationConfig, 0, AIGC_VERSION);
    }
    IdlAigcServiceImpl.themeStateMap.set(themeId, { errCode: errorCode,
      statusCode: AigcStatus.AIGC_STATUS_FINISH, internalStatus: InternalStatus.IDLE});
    if (this.needTerminate()) {
      this.waitAndTerminate();
    }
    try {
      // commonEventManager.publish(AIGCConstants.AIGC_GENERATE_FINISHED,
      //   {data: themeId, parameters: {errorCode: errorCode, isFirst: isFirst}}, this.onPublish);
    } catch (err) {
      // Log.error(TAG, `publish error. Code is ${err?.code}, message is ${err?.message}`);
    }

    // 对轮播图触发使能后，发送使能完成通知。
    // Log.info(TAG, 'active theme finished.')
  }

  private onPublish(err: BusinessError): void {
    if (err) {
      // Log.error(TAG, `publishThemeLoaded failed, code is ${err.code}, message is ${err.message}`);
      return;
    }
    // Log.info(TAG, 'Succeeded publish event: AIGCFinished');
  }

  private async doForColorPicker(pixelMap: image.PixelMap, filePath: string): Promise<void> {
    // Log.info(TAG, `doForColorPicker start`);
    const lightDegree: effectKit.PictureLightColorDegree | null =
      await AigcWallpaperColorManager.getLightDegree(pixelMap);
    if (lightDegree === null) {
      // Log.error(TAG, 'get light degree error, status bar area may display not properly');
      return;
    }
    // Log.info(TAG, `lightColorDegree is ${lightDegree}.`);
    if (lightDegree === EXTREMELY_LIGHT_COLOR_PICTURE) {
      await AigcWallpaperColorManager.darkStatusArea(pixelMap);
      await AigcPixelmapUtils.saveImage2Disk(filePath, pixelMap);
    }
  }

  private async copyAndDimFiles(srcFile: string, lockFile: string, dimLockFile: string, xOffset: number,
    yOffset: number): Promise<void> {
      let src: image.PixelMap | undefined = AigcPixelmapUtils.loadPixelMap(srcFile);
      try {
        if (src === undefined) {
          // Log.error(TAG, `copyAndDimFiles failed to create pixel map for dim image ${srcFile}.`);
          return;
        }
        if (this.isWaterMarkEnable) {
          src = await AigcPixelmapUtils.addWaterMark(src, xOffset, yOffset);
          if (!await AigcPixelmapUtils.saveImage2Disk(srcFile, src)) {
            // Log.warn(TAG, `copyAndDimFiles failed to add water mark.`);
          }
        }
        await this.doForColorPicker(src, srcFile);
        let isDimFinish: boolean = false
          // AigcSdk.dimImage(src, src, AOD_DIM_FACTOR) && await AigcPixelmapUtils.saveImage2Disk(dimLockFile, src);
        // 保证完成压暗并且文件写入成功后，再将生成图从download目录拷贝到轮播目录
        if (isDimFinish) {
          fs.copyFileSync(srcFile, lockFile);
          await AigcPixelmapUtils.addAIGCExif(lockFile);
        } else {
          // Log.error(TAG, `copyAndDimFiles failed to process dim ${srcFile}, so this wallpaper will not display.`);
        }
      } catch (error) {
        // Log.error(TAG, `copyAndDimFiles failed: : ${error?.code}, ${error?.message}`);
      } finally {
        src?.release();
      }
  }

  private async prepareWpFromDownloadToCarousel(themeId: string): Promise<boolean> {
    try {
      // Log.info(TAG, `prepareWpFromDownloadToCarousel start.`);
      let themeDownloadDir: string = AigcConstant.DOWNLOAD_DIR + '/' + themeId;
      let themeCarouselDir: string = AigcConstant.CAROUSEL_DIR + '/' + themeId;
      let themeCarouselUnfoldedDir: string = AigcConstant.CAROUSEL_UNFOLDED_DIR + '/' + themeId;
      let fileNames: string[] = fs.listFileSync(themeDownloadDir).sort();
      if (!fs.accessSync(themeCarouselDir)) {
        // Log.info(TAG, `prepareWpFromDownloadToCarousel CAROUSEL_DIR not exist, mkdir ${themeCarouselDir}`);
        fs.mkdirSync(themeCarouselDir, true);
      }
      // this.isWaterMarkEnable = DynamicUtils.getWatermarkStatus();
      let isBigFoldDevice: boolean = false
        // DeviceHelper.isFoldButNotSmallFoldProduct();
      // if (isBigFoldDevice || DeviceHelper.isNexSmallFold()) {
      if (isBigFoldDevice) {
        await this.copyAndClipAllFoldDeviceCarouselPics(themeDownloadDir, fileNames, themeId,
          themeCarouselDir, themeCarouselUnfoldedDir);
      } else {
        let existFilesCount: number = fs.listFileSync(themeCarouselDir, {
          filter: {
            displayName: ['unlock_wallpaper_*.jpg']
          }
        }).length;
        let copyFileCount: number = Math.min(fileNames.length, AigcConstant.MAX_FILE_COUNT - existFilesCount);
        for (let i: number = 0; i < copyFileCount; i++) {
          let currFile: string = themeDownloadDir + '/' + fileNames[i];
          let curCarouselFileName: string = `/unlock_wallpaper_${new Date().getTime()}_${i + 1}.jpg`;
          let destFile: string = themeCarouselDir + curCarouselFileName;
          const dimFile: string = curCarouselFileName.replace('unlock', 'aod');
          // Log.info(TAG, `copyAndDimFiles start copy ${fileNames[i]} to ${curCarouselFileName} and dim to ${dimFile}`);
          await this.copyAndDimFiles(currFile, destFile, themeCarouselDir + dimFile, AigcConstant.WATER_MARK_X_V1,
            AigcConstant.WATER_MARK_Y_V1);
        }
      }
      // Log.info(TAG, `prepareWpFromDownloadToCarousel finish.`);
      return true;
    } catch (err) {
      // Log.error(TAG, `prepareWpFromDownloadToCarousel error. Code is ${err?.code}, message is ${err?.message}`);
      return false;
    }
  }

  /**
   *  折叠屏复制轮播图
   *
   * @param downloadDir 下载的地址
   * @param fileNames 出图的文件名
   * @param themeId themeID
   * @param themeCarouselDir 折叠态轮播图路径
   * @param themeCarouselUnfoldedDir 展开态轮播图路径
   */
  private async copyAndClipAllFoldDeviceCarouselPics(downloadDir: string, fileNames: string[],
    themeId: string, themeCarouselDir: string, themeCarouselUnfoldedDir: string): Promise<void> {
    let styles: string[] = [];
    if (!fs.accessSync(themeCarouselUnfoldedDir)) {
      // Log.info(TAG, `copyFilesToCarousel CAROUSEL_UNFOLDED_DIR not exist, mkdir ${themeCarouselUnfoldedDir}`);
      fs.mkdirSync(themeCarouselUnfoldedDir, true);
    }
    let existFilesCount: number = 0;
    try {
      existFilesCount = fs.listFileSync(themeCarouselUnfoldedDir, {
        filter: {
          displayName: ['unlock_wallpaper_*.jpg']
        }
      }).length;
    } catch (error) {
      // Log.error(TAG, `No wallpaper in unfolded carousel dir.`);
    }
    let copyFileCount: number = Math.min(fileNames.length, AigcConstant.MAX_FILE_COUNT - existFilesCount);
    let areas: image.Region[] = []
      // await PandoraUtils.getFoldProductMultiClipRegions(themeId);
    for (let i: number = 0; i < copyFileCount; i++) {
      let currFile: string = downloadDir + '/' + fileNames[i];
      let curCarouselFileName: string = `/unlock_wallpaper_${new Date().getTime()}_${i + 1}.jpg`;
      let destFile: string = themeCarouselDir + curCarouselFileName;
      let destUnfoldedFile: string = themeCarouselUnfoldedDir + curCarouselFileName;
      let copyAreas: image.Region[] = this.getCopyAreas(areas);
      await this.doCopyClipAndDimFile(currFile, destFile, copyAreas[0], AigcConstant.WATER_MARK_X_V1_FOLD,
        AigcConstant.WATER_MARK_Y_V1_FOLD);
      await this.doCopyClipAndDimFile(currFile, destUnfoldedFile, copyAreas[1], AigcConstant.WATER_MARK_X_V1_UNFOLD,
        AigcConstant.WATER_MARK_Y_V1_FOLD);
    }
  }

  /**
   * 返回2个, 折叠态和展开态的区域, 不够补全！
   */
  private getCopyAreas(originRegions: image.Region[]): image.Region[] {
    let res: image.Region[] = [];
    for (let i = 0; i < originRegions.length; i++) {
      let region: image.Region = originRegions[i];
      res.push({
        x: region.x, y: region.y, size: {
          height: region.size.height, width: region.size.width
        }
      });
    }
    for (let i = res.length; i < 2; i++) {
      res[i] = {
        x: 0, y: 0, size: {
          height: 1, width: 1
        }
      };
    }
    return res;
  }

  private async doCopyClipAndDimFile(currFile: string, destFile: string, area: image.Region, waterMarkWidth: number,
    waterMarkHeight: number): Promise<void> {
    // Log.info(TAG, `doCopyClipAndDimFile ${currFile} to ${destFile}`);
    let currSrc: image.PixelMap | undefined = AigcPixelmapUtils.loadPixelMap(currFile);
    if (currSrc === undefined) {
      // Log.error(TAG, `doCopyClipAndDimFile failed to create pixel map for dim image ${currFile}.`);
      return;
    }
    let imageSize: image.Size = currSrc.getImageInfoSync().size;
    if (imageSize.height <= 1 || imageSize.width <= 1) {
      // Log.error(TAG, `doCopyClipAndDimFile imageSize error ${currFile}`);
      return;
    }
    // PandoraUtils.scaleRegions(imageSize.width, imageSize.height, area);
    // Log.info(TAG, `doCopyClipAndDimFile cropArea xywh[${area.x}, ${area.y}, ${area.size.width}, ${area.size.height}]`);
    currSrc.cropSync(area);
    if (this.isWaterMarkEnable) {
      currSrc = await AigcPixelmapUtils.addWaterMark(currSrc, waterMarkWidth, waterMarkHeight);
    }
    const lightDegree: effectKit.PictureLightColorDegree | null =
      await AigcWallpaperColorManager.getLightDegree(currSrc);
    if (lightDegree !== null && lightDegree === EXTREMELY_LIGHT_COLOR_PICTURE) {
      await AigcWallpaperColorManager.darkBigFoldStatusArea(currSrc);
    }
    const dimFile: string = destFile.replace('unlock', 'aod');
    await AigcPixelmapUtils.saveImage2Disk(destFile, currSrc);
    await AigcPixelmapUtils.addAIGCExif(destFile);
    // AigcSdk.dimImage(currSrc, currSrc, AOD_DIM_FACTOR) &&
    //   await AigcPixelmapUtils.saveImage2Disk(dimFile, currSrc);
    currSrc?.release();
  }

  private async isReadyForActivate(themeId: string, themeCarouselDir: string,
    themeCarouselUnfoldedDir: string): Promise<boolean> {
    try {
      if (!fs.accessSync(themeCarouselDir)) {
        // Log.warn(TAG, `isReadyForActivate themeCarouselDir not exists.`);
        return false;
      }
      // if ((DeviceHelper.isFoldButNotSmallFoldProduct() || DeviceHelper.isNexSmallFold()) &&
      //   !fs.accessSync(themeCarouselUnfoldedDir)) {
      if (!fs.accessSync(themeCarouselUnfoldedDir)) {
        // Log.warn(TAG, `isReadyForActivate themeCarouselUnfoldedDir not exists.`);
        return false;
      }
      return true;
    } catch (err) {
      // Log.error(TAG, `isReadyForActivate check error. Code is ${err?.code}, message is ${err?.message}`);
      return false;
    }
  }

  private async prepareDirByCurr(currActiveThemeDir: string, toActivateThemePath: string): Promise<boolean> {
    // Log.info(TAG, `prepareDirByCurr start`)
    try {
      if (fs.accessSync(toActivateThemePath)) {
        fs.rmdirSync(toActivateThemePath);
      }
      fs.mkdirSync(toActivateThemePath, true);
      // 复制主题目录到当前临时目录
      fs.copyDirSync(currActiveThemeDir + '/aod', toActivateThemePath);
      fs.copyDirSync(currActiveThemeDir + '/lock', toActivateThemePath);
      fs.copyDirSync(currActiveThemeDir + '/home', toActivateThemePath);
      fs.copyDirSync(currActiveThemeDir + '/long_take', toActivateThemePath);
      this.unlinkOtherImages(toActivateThemePath + '/aod/base/resources', currActiveThemeDir, 'aod');
      this.unlinkOtherImages(toActivateThemePath + '/lock/base/resources', currActiveThemeDir, 'lock');
      this.unlinkOtherImages(toActivateThemePath + '/home/base/resources', currActiveThemeDir, 'home');
      AigcFileUtils.clearDirectory(`${toActivateThemePath}/long_take/base/resources/wallpaper/base/`, ['.jpg']);
      // Log.info(TAG, `prepareDirByCurr finish`);
      return true;
    } catch (err) {
      // Log.error(TAG, `prepareDirByCurr error. Code is ${err?.code}, message is ${err?.message}`);
      return false;
    }
  }

  private async prepareUnfoldedDirByCurr(currActiveThemeDir: string, toActivateThemePath: string): Promise<boolean> {
    // Log.info(TAG, `prepareUnfoldedDirByCurr start`);
    try {
      this.unlinkOtherImages(toActivateThemePath + '/aod/unfolded/resources', currActiveThemeDir, 'aod');
      this.unlinkOtherImages(toActivateThemePath + '/lock/unfolded/resources', currActiveThemeDir, 'lock');
      this.unlinkOtherImages(toActivateThemePath + '/home/unfolded/resources', currActiveThemeDir, 'home');
      AigcFileUtils.clearDirectory(`${toActivateThemePath}/long_take/unfolded/resources/wallpaper/base/`, ['.jpg']);
      // Log.info(TAG, `prepareUnfoldedDirByCurr finish`);
      return true;
    } catch (err) {
      // Log.error(TAG, `prepareUnfoldedDirByCurr error. Code is ${err?.code}, message is ${err?.message}`);
      return false;
    }
  }

  private async prepareNexSmallFoldSubScreenDirByCurr(currActiveThemeDir: string,
    toActivateThemePath: string): Promise<boolean> {
    try {
      let fromSubScreenDir: string = `${currActiveThemeDir}/sub_screen`;
      if (!fs.accessSync(fromSubScreenDir)) {
        // Log.info(TAG, `This theme does not apply in subscreen`);
        return true;
      }
      let toTmpSubScreenDir: string = `${toActivateThemePath}/sub_screen`;
      // Log.info(TAG, `prepareNexSmallFoldSubScreenDirByCurr start, currActiveThemeDir is ${
      // currActiveThemeDir}, toTmpSubScreenDir is ${toTmpSubScreenDir}`);
      if (fs.accessSync(toTmpSubScreenDir)) {
        fs.rmdirSync(toTmpSubScreenDir);
      }
      fs.mkdirSync(toTmpSubScreenDir, true);
      fs.copyDirSync(`${fromSubScreenDir}/aod`, toTmpSubScreenDir);
      fs.copyDirSync(`${fromSubScreenDir}/lock`, toTmpSubScreenDir);
      fs.copyDirSync(`${fromSubScreenDir}/home`, toTmpSubScreenDir);
      fs.copyDirSync(`${fromSubScreenDir}/long_take`, toTmpSubScreenDir);
      this.unlinkOtherImages(`${toTmpSubScreenDir}/aod/base/resources`, fromSubScreenDir, 'aod');
      this.unlinkOtherImages(`${toTmpSubScreenDir}/lock/base/resources`, fromSubScreenDir, 'lock');
      this.unlinkOtherImages(`${toTmpSubScreenDir}/home/base/resources`, fromSubScreenDir, 'home');
      AigcFileUtils.clearDirectory(`${toTmpSubScreenDir}/long_take/base/resources/wallpaper/base/`, ['.jpg']);
      return true;
    } catch (err) {
      // Log.error(TAG, `prepareNexSmallFoldSubScreenDirByCurr error. Code is ${err?.code}, message is ${err?.message}`);
      return false;
    }
  }

  private prepareDirByCarousel(themeCarouselDir: string, toActivatePath: string,
    screenType: string = '' || 'sub_screen'): boolean {
    // Log.info(TAG, `prepareDirByCarousel start`)
    const toActivateScreenPath: string = `${toActivatePath}/${screenType}`;
    try {
      const wallpaperList: string[] =
        fs.listFileSync(themeCarouselDir, { filter: { displayName: ['unlock_wallpaper_*.jpg'] } }).sort();
      const wallpaperCnt: number = wallpaperList.length;
      if (wallpaperCnt === 0) {
        // Log.error(TAG, 'prepareDirByCarousel No wallpaper in carousel dir, so this theme will not be activated');
        return false;
      }

      if (!fs.accessSync(toActivateScreenPath) && screenType === 'sub_screen') {
        // Log.info(TAG, `prepareDirByCarousel toActivateScreenPath is not existed, do not need to copy wallpaper`);
        return true;
      }
      this.copyWpFromCarousel(themeCarouselDir, wallpaperList, toActivateScreenPath, 'base');

      // const lockManifestPath: string = `${toActivateScreenPath}/${PandoraConstants.LOCK_MANIFEST_PATH}`;
      // let lockManifestContent: GalleryCardLockConfig =
      //   JSON.parse(FileUtil.getStringByFile(lockManifestPath)) as GalleryCardLockConfig;
      // lockManifestContent.type = wallpaperCnt === 1 ? 'image' : 'longTake';
      // FileUtil.createFileWithJsonObject(lockManifestPath, lockManifestContent);
      // const homeManifestPath: string = `${toActivateScreenPath}/${PandoraConstants.HOME_MANIFEST_PATH}`;
      // let homeManifestContent: HomeManifest =
      //   JSON.parse(FileUtil.getStringByFile(homeManifestPath)) as HomeManifest;
      // homeManifestContent.type = wallpaperCnt === 1 ? 'image' : 'longTake';
      // FileUtil.createFileWithJsonObject(homeManifestPath, homeManifestContent);
      // const toActivateLongTakeScript: string = `${toActivateScreenPath}/long_take/base/script.json`;
      // AigcFileUtils.editJsonScript(toActivateLongTakeScript, 'wallpaperCount', `${wallpaperList.length}`);
      // Log.info(TAG, `prepareDirByCarousel finish`);
      return true;
    } catch (err) {
      // Log.error(TAG, `prepareDirByCarousel error. Code is ${err?.code}, message is ${err?.message}`);
      return false;
    }
  }

  private copyWpFromCarousel(carouselPath: string, carouselWp: string[], toActivatePath: string,
    qualifier: 'base' | 'unfolded'): boolean {
    try {
      const dstDir: string = `${toActivatePath}/long_take/base/resources/wallpaper/${qualifier}`;
      carouselWp.forEach((fileName: string, index: number) => {
        const srcAodFile: string = `${carouselPath}/${fileName.replace('unlock', 'aod')}`;
        const srcLockFile: string = `${carouselPath}/${fileName}`;
        if (fs.accessSync(srcAodFile)) {
          // 第一张生成图画廊、壁纸等展示
          if (index === 0) {
            fs.copyFileSync(srcAodFile, `${dstDir}/aod_wallpaper_0.jpg`);
            fs.copyFileSync(srcAodFile, `${toActivatePath}/aod/${qualifier}/resources/aod_wallpaper_0.jpg`);
            fs.copyFileSync(srcLockFile, `${dstDir}/unlock_wallpaper_0.jpg`);
            fs.copyFileSync(srcLockFile, `${toActivatePath}/lock/${qualifier}/resources/unlock_wallpaper_0.jpg`);
            fs.copyFileSync(srcLockFile, `${toActivatePath}/home/${qualifier}/resources/home_wallpaper_0.jpg`);
          }
          // 生成图全部拷贝到long_take目录下，用作引擎渲染
          const dstLockFile: string = `${dstDir}/unlock_wallpaper_${index + 1}.jpg`;
          const dstAodFile: string = `${dstDir}/aod_wallpaper_${index + 1}.jpg`;
          fs.copyFileSync(srcAodFile, dstAodFile);
          fs.copyFileSync(srcLockFile, dstLockFile);
          // Log.info(TAG, `copyWpFromCarousel finish copy ${fileName} to long_take dir ${dstLockFile}.`);
        } else {
          // Log.warn(TAG, `copyWpFromCarousel to long_take no dim image for ${
          //   fileName}, so this wallpaper will not display`);
        }
      })
      return true;
    } catch (err) {
      // Log.error(TAG, `copyWpFromCarousel to long_take error. Code is ${err?.code}, message is ${err?.message}`);
      return false;
    }
  }

  private prepareUnfoldedDirByCarousel(themeCarouselUnfoldedDir: string, toActivatePath: string): boolean {
    // Log.info(TAG, `prepareUnfoldedDirByCarousel start`);
    const unfoldWallpaperList: string[] = fs.listFileSync(themeCarouselUnfoldedDir, {
      filter: {
        displayName: ['unlock_wallpaper_*.jpg']
      }
    }).sort();
    const unfoldWallpaperCnt: number = unfoldWallpaperList.length;
    if (unfoldWallpaperCnt === 0) {
      // Log.error(TAG, 'prepareUnfoldedDirByCarousel No wallpaper in UnfoldWallpaper dir');
      return false;
    }
    return this.copyWpFromCarousel(themeCarouselUnfoldedDir, unfoldWallpaperList, toActivatePath, 'unfolded');
  }

  private async activateThemeByCarousel(themeId: string, isEnableNotify: boolean): Promise<boolean> {
    try {
      // Log.info(TAG, `activateThemeByCarousel start.`);
      let themeCarouselDir: string = AigcConstant.CAROUSEL_DIR + '/' + themeId;
      let themeCarouselUnfoldedDir: string = AigcConstant.CAROUSEL_UNFOLDED_DIR + '/' + themeId;
      let isReady: boolean = await this.isReadyForActivate(themeId, themeCarouselDir, themeCarouselUnfoldedDir);
      if (!isReady) {
        // Log.error(TAG, `activateThemeByCarousel cannot activate pandora theme now`);
        return false;
      }
      // 拷贝A/B目录到临时激活目录，用作后续使能(主要是需要原图以及相关配置文件)
      const toActivateThemePath: string = AigcConstant.TEMP_DIR;
      let activeThemePath: string = this.getActiveThemePath(themeId);
      if (!await this.prepareDirByCurr(activeThemePath, toActivateThemePath)) {
        return false;
      }
      let isBigFoldDevice: boolean = true
        // DeviceHelper.isFoldButNotSmallFoldProduct();
      let isNexFold: boolean = true
        // DeviceHelper.isNexSmallFold();
      if (isBigFoldDevice) {
        await this.prepareUnfoldedDirByCurr(activeThemePath, toActivateThemePath);
      } else if (isNexFold) {
        await this.prepareNexSmallFoldSubScreenDirByCurr(activeThemePath, toActivateThemePath);
      }
      if (!this.prepareDirByCarousel(themeCarouselDir, toActivateThemePath, '')) {
        return false;
      }
      if (isBigFoldDevice && !this.prepareUnfoldedDirByCarousel(themeCarouselUnfoldedDir, toActivateThemePath)) {
        return false;
      }
      if (isNexFold && !this.prepareDirByCarousel(themeCarouselUnfoldedDir, toActivateThemePath, 'sub_screen')) {
        return false;
      }
      let activateStatus: AigcCurrentThemeStatus = await this.getCurrentThemeStatus(themeId);
      let isActivateSucc: boolean = await this.activateThemeByDir(themeId, toActivateThemePath, activateStatus);
      fs.rmdirSync(AigcConstant.TEMP_DIR);
      return isActivateSucc;
    } catch (err) {
      // Log.error(TAG, `ActivatePandoraTheme error. Code is ${err?.code}, message is ${err?.message}`);
      return false;
    }
  }

  private async activateAsOuterThemeByDir(arg: EditThemeArg, option: ThemeOptions): Promise<boolean> {
    // 刷新外屏ab目录
    option.enableSubScreen().enableLongTake();
    arg.activate = true;
    arg.option = option;
    let midRetCode: boolean = await TsRemoteCaller.getInstance(this.context).editTheme(arg);
    // 对内屏作仅资源的刷新
    let secondOption: ThemeOptions = new ThemeOptions();
    arg.activate = false;
    secondOption.enableAod().enableLock().enableHome().enableLongTake();
    arg.option = secondOption;
    let retCode: boolean = await TsRemoteCaller.getInstance(this.context).editTheme(arg);
    // Log.info(TAG, `out screen: activateTheme finish and retcode is ${retCode}, midRetCode is ${midRetCode}.`);
    return retCode;
  }

  private async activateAsInnerThemeByDir(arg: EditThemeArg, option: ThemeOptions,
    // configJson: PandoraConfig): Promise<boolean> {
    configJson: ESObject): Promise<boolean> {
    // 刷新内屏ab目录
    option.enableAod().enableLock().enableHome().enableLongTake();
    arg.activate = true;
    arg.option = option;
    let midRetCode: boolean = await TsRemoteCaller.getInstance(this.context).editTheme(arg);
    // 弹窗选择仅内屏场景，只刷新内屏资源
    if (this.typeScreenConversion(configJson?.isApplyToMain) &&
      !this.typeScreenConversion(configJson?.isApplyToCover)) {
      return midRetCode;
    }
    // 对外屏作仅资源的刷新
    let secondOption: ThemeOptions = new ThemeOptions();
    arg.activate = false;
    secondOption.enableLongTake().enableSubScreen();
    arg.option = secondOption;
    let retCode: boolean = await TsRemoteCaller.getInstance(this.context).editTheme(arg);
    // Log.info(TAG, `inner screen: activateTheme finish and retcode is ${retCode}, midRetCode is ${midRetCode}.`);
    return retCode;
  }

  private async activateAsFullThemeByDir(arg: EditThemeArg, option: ThemeOptions): Promise<boolean> {
    // 内外屏全量刷新
    option.enableAod().enableLock().enableHome().enableLongTake().enableSubScreen();
    arg.activate = true;
    arg.option = option;
    let retCode: boolean = await TsRemoteCaller.getInstance(this.context).editTheme(arg);
    // Log.info(TAG, `full screen: activateTheme finish and retcode is ${retCode}.`);
    return retCode;
  }

  private async activateAsNoThemeByDir(arg: EditThemeArg, option: ThemeOptions,
    // configJson: PandoraConfig): Promise<boolean> {
    configJson: ESObject): Promise<boolean> {
    // 弹窗选择仅内屏场景，只刷新内屏资源
    if (this.typeScreenConversion(configJson?.isApplyToMain) &&
      !this.typeScreenConversion(configJson?.isApplyToCover)) {
      option.enableAod().enableLock().enableHome().enableLongTake();
    } else {
      // 内外屏均仅刷新资源
      option.enableAod().enableLock().enableHome().enableLongTake().enableSubScreen();
    }
    arg.activate = false;
    arg.option = option;
    let retCode: boolean = await TsRemoteCaller.getInstance(this.context).editTheme(arg);
    // Log.info(TAG, `no screen: activateTheme finish and retcode is ${retCode}.`);
    return retCode;
  }

  private async activateThemeByDirForSmallFold(arg: EditThemeArg, option: ThemeOptions,
    activateStatus: AigcCurrentThemeStatus, configJson: ESObject): Promise<boolean> {
    // activateStatus: AigcCurrentThemeStatus, configJson: PandoraConfig): Promise<boolean> {
    let retCode: boolean = false;
    if (activateStatus === AigcCurrentThemeStatus.OUTER_PANDORA) {
      retCode = await this.activateAsOuterThemeByDir(arg, option);
    }
    if (activateStatus === AigcCurrentThemeStatus.INNER_PANDORA) {
      retCode = await this.activateAsInnerThemeByDir(arg, option, configJson);
    }
    if (activateStatus === AigcCurrentThemeStatus.FULL_PANDORA) {
      retCode = await this.activateAsFullThemeByDir(arg, option);
    }
    if (activateStatus === AigcCurrentThemeStatus.NO_PANDORA) {
      retCode = await this.activateAsNoThemeByDir(arg, option, configJson);
    }
    return retCode;
  }

  private async activateThemeByDir(editorID: string, toActivatePath: string,
    activateStatus: AigcCurrentThemeStatus): Promise<boolean> {
    let arg: EditThemeArg = new EditThemeArg(editorID, 'Pandora');
    let option: ThemeOptions = new ThemeOptions();
    arg.customPath = toActivatePath;
    const configDir: string = ''
      // PandoraUtils.getConfigDir() + '/' + editorID;
    // let configJson: PandoraConfig | undefined = this.getPandoraConfig(configDir);
    let configJson: ESObject | undefined = undefined;
    // Log.info(TAG, `activateThemeByDir EXEC path:${configDir}` +
    //   `toMain:${configJson?.isApplyToMain} toCover:${configJson?.isApplyToCover}`);
    // if (DeviceHelper.isNexSmallFold()) {
    //   if (configJson !== undefined) {
    //     let retCode: boolean = await this.activateThemeByDirForSmallFold(arg, option, activateStatus, configJson);
    //     return retCode;
    //   }
    //   Log.error(TAG, 'activateAndBeginPandora getConfigContent fail');
    //   return false;
    // }
    if (activateStatus !== AigcCurrentThemeStatus.NO_PANDORA) {
      arg.activate = true;
    } else {
      arg.activate = false;
    }
    option.enableAod().enableLock().enableHome().enableLongTake();
    arg.option = option;
    let retCode = await TsRemoteCaller.getInstance(this.context).editTheme(arg);
    // Log.info(TAG, `activateTheme finish and retcode is ${retCode}.`);
    return retCode;
  return true;
  }

  private getActiveThemePath(editorID: string): string {
    return `/data/storage/el1/base/files/theme_service/t_pkg/${editorID}`;
  }

  private getMashupSrcPath(activeThemePath: string, type: string): string {
    let srcPath: string = '';
    let manifestPath: string = `${activeThemePath}/${type}/manifest.json`;
    if (!fs.accessSync(manifestPath)) {
      // Log.info(TAG, `No manifest file for ${type}.`);
      return '';
    }
    let manifestContent: object | null = null;
    try {
      manifestContent = JSON.parse(fs.readTextSync(manifestPath));
    } catch (err) {
      // Log.info(TAG, `Parse manifest file error. Code is ${err?.code}, message is ${err?.message}`);
      return '';
    }
    if (!manifestContent) {
      // Log.info(TAG, `Manifest content for ${type} wallpaper is null.`);
      return '';
    }
    const isFixed: boolean = manifestContent['applyFrom'] !== undefined;
    if (isFixed && manifestContent['image'] !== undefined && manifestContent['image']['src'] !== undefined) {
      srcPath = manifestContent['image']['src'];
      // Log.info(TAG, `Mashup source path for ${type} is ${srcPath}`);
    }
    return srcPath;
  }

  private unlinkOtherImages(themeRscDir: string, activeThemePath: string, type: string = 'lock'): boolean {
    // Log.info(TAG, `unlinkOtherImages called`);
    let srcPath: string = this.getMashupSrcPath(activeThemePath, type);
    try {
      if (fs.accessSync(themeRscDir)) {
        fs.listFileSync(themeRscDir, { filter: { suffix: ['.jpg'] } }).forEach((fileName) => {
          if (fileName.endsWith('0.jpg') || (srcPath !== '' && fileName === srcPath)) {
            return;
          }
          let toUnlinkPath: string = themeRscDir + '/' + fileName;
          // Log.info(TAG, `unlinkOtherImages unlinkSync: ${fileName}`);
          fs.unlinkSync(toUnlinkPath);
        })
        return true;
      } else {
        return false;
      }
    } catch (error) {
      // Log.error(TAG, `unlinkOtherImages Error: ${error?.code}, ${error?.message}`);
      return false;
    }
  }

  private async getCurrentThemeStatus(themeId: string): Promise<AigcCurrentThemeStatus> {
    // Log.info(TAG, `[getCurrentThemeStatus] start search theme ${themeId}`);
    // 获取当前主题
    let currentTheme: NullableType<ThemeInfoNew> = await TsRemoteCaller.getInstance(this.context).getCurrentTheme();

    // 小折叠产品独立识别内外屏主题场景
    // if (DeviceHelper.isNexSmallFold()) {
    //   Log.info(TAG, `[getCurrentThemeStatus] find current themeId = ${currentTheme?.editorId}`);
    //   let innerFlag: boolean = false;
    //   if (themeId === currentTheme?.editorId) {
    //     innerFlag = true;
    //   }
    //   let outerFlag: boolean = false;
    //   let subScreenInfos: SubScreenInfo[] = await TsRemoteCaller.getInstance(this.context).getSubScreenThemes();
    //   for (let listIndex = 0; listIndex < subScreenInfos.length; listIndex++) {
    //     let subScreenInfo: SubScreenInfo = subScreenInfos[listIndex];
    //     if (subScreenInfo.isEnabled && subScreenInfo.suiteEditorId === themeId) {
    //       Log.info(TAG, `[getCurrentThemeStatus] find pandora ${subScreenInfo.themeId} -> ` +
    //         `${subScreenInfo.suiteEditorId}`);
    //       outerFlag = true;
    //     }
    //   }
    //   Log.info(TAG, `[getCurrentThemeStatus] small fold has inner ${innerFlag}, outer ${outerFlag}`);
    //   if (outerFlag && innerFlag) {
    //     return AigcCurrentThemeStatus.FULL_PANDORA;
    //   }
    //   if (outerFlag && !innerFlag) {
    //     return AigcCurrentThemeStatus.OUTER_PANDORA;
    //   }
    //   if (!outerFlag && innerFlag) {
    //     return AigcCurrentThemeStatus.INNER_PANDORA;
    //   }
    //   return AigcCurrentThemeStatus.NO_PANDORA;
    // }
    if (themeId === currentTheme?.editorId) {
      return AigcCurrentThemeStatus.FULL_PANDORA;
    }
    return AigcCurrentThemeStatus.NO_PANDORA;
  }

  private needTerminate(): boolean {
    let needTerminate: boolean = true;
    IdlAigcServiceImpl.themeStateMap.forEach((value, themeId) => {
      if (value.statusCode === AigcStatus.AIGC_STATUS_ONGOING) {
        needTerminate = false;
      }
    })
    return needTerminate;
  }

  private async generateImagesCallback(errCode: number, themeID: string): Promise<void> {
    // Log.info(TAG, `Pandora_Task_${themeID} finish, result is ${errCode}`);
    if (errCode === 0) {
      const imageDownloadDir: string = `${AigcConstant.DOWNLOAD_DIR}/${themeID}`;
      if (!fs.accessSync(imageDownloadDir)) {
        // Log.error(TAG, `generateImageCallback download dictionary not exists.`);
      } else {
        await this.prepareWpFromDownloadToCarousel(themeID) && await this.activateThemeByCarousel(themeID, true);
        fs.rmdirSync(imageDownloadDir);
      }
      AigcNotificationManager.getInstance().sendNotice(themeID, AigcNoticeType.FINISH, this.notificationConfig);
    } else {
      AigcNotificationManager.getInstance().sendNotice(themeID, AigcNoticeType.FAIL, this.notificationConfig, errCode);
    }

    // const themeConfigPath: string = `${PandoraUtils.getConfigDir()}/${themeID}`;
    // let configJson: PandoraConfig | undefined = this.getPandoraConfig(themeConfigPath);
    // if (configJson === undefined) {
    //   Log.error(TAG, 'processActivateAndRequest in requestImage callback, getConfigContent fail');
    //   return;
    // }
    // status和notifyErrCode需要写入config
    // configJson.status =
    //   errCode === 0 ? AIGCEditorStatus.FIRST_GENERATE_AI_SUCCESS : AIGCEditorStatus.FIRST_GENERATE_AI_FAILED;
    // configJson.notifyErrCode = errCode;
    // await AigcFileUtils.createFileWithJsonObject(`${themeConfigPath}/${CONFIG_NAME}`, configJson);

    // commonEventManager.publish(AIGCConstants.AIGC_GENERATE_FINISHED, {
    //   data: themeID,
    //   parameters: { errorCode: errCode }
    // }, this.onPublish);
    // IdlAigcServiceImpl.themeStateMap.set(themeID, {errCode: errCode,
    //   statusCode: AigcStatus.AIGC_STATUS_FINISH,
    //   internalStatus: InternalStatus.VALID
    // });
    if (this.needTerminate()) {
      this.waitAndTerminate();
    }
  }

  /**
   * 设置折叠屏壁纸 折叠态、展开态的裁切区域
   *
   * @param themeId themeId
   * @param foldedClipAreas 出图的大小、折叠态、展开态的裁切区域
   * @param callback 端侧回调
   */
  public setFoldedClipAreas(themeId: string, foldedClipAreas: string, callback: operateResult): void {
    // Log.info(TAG, `setFoldedClipAreas called themeId: ${themeId}, areas ${foldedClipAreas}`);
    try {
      // PandoraUtils.setFoldProductMultiClipAreasStr(themeId, foldedClipAreas);
      callback(IdlAigcServiceImpl.SUCCESS);
    } catch (err) {
      // Log.error(TAG, `setFoldedClipAreas failed msg. Code is ${err?.code}, message is ${err?.message}`);
      callback(IdlAigcServiceImpl.FAIL);
    }
  }

  /**
   * 使能、创建配置文件并且开始生成
   *
   * @param paramList 结构为[预制包路径, 沙箱路径, 配置文件夹相对路径, uid, token, algParam]
   * @param callback 端侧回调
   */
  public activateAndBeginPandora(paramList: string[], version: string, callback: operateResult): void {
    // Log.info(TAG, `activateAndBeginPandora paramList count ${paramList.length}`);
    this.removeTerminateTimer();
    this.activateAndBeginPandoraAsync(paramList, version, callback);
  }

  private typeScreenConversion(type: number | undefined): boolean {
    if (type === undefined) {
      // Log.error(TAG, 'typeScreenConversion type is undefined');
      return false;
    }
    return type === 0 ? true : false;
  }

  private async activateAndBeginPandoraAsync(paramList: string[], version: string, callback: operateResult):
    Promise<void> {
    if (paramList.length !== ACTIVATE_AND_BEGIN_PANDORA_PARAM_COUNT) {
      // Log.error(TAG, 'activateAndBeginPandora param number wrong');
      callback(IdlAigcServiceImpl.FAIL);
      return;
    }
    const presetPath: string = paramList[0];
    const sandBoxPath: string = paramList[1];
    const configRelativePath: string = paramList[2];
    const uid: string = paramList[3];
    const token: string = paramList[4];
    const algParam: string = paramList[5];
    try {
      const tmpThemePath: string = ''
        // sandBoxPath + '/' + PandoraConstants.TMP_DIR
      const configDir: string = sandBoxPath + '/' + configRelativePath;
      // let configJson: PandoraConfig | undefined = this.getPandoraConfig(configDir);
      let configJson: ESObject | undefined = undefined;
      Log.info(TAG, `activateAndBeginPandoraAsync EXEC path:${configDir}` +
        `toMain:${configJson?.isApplyToMain} toCover:${configJson?.isApplyToCover}`);
      if (configJson === undefined) {
        Log.error(TAG, 'activateAndBeginPandora getConfigContent fail');
        callback(IdlAigcServiceImpl.FAIL);
        return;
      }
      let themeId: string =
        await this.activateNewTheme(presetPath, tmpThemePath, this.typeScreenConversion(configJson?.isApplyToMain),
          this.typeScreenConversion(configJson?.isApplyToCover));
      if (themeId.length === 0) {
        Log.error(TAG, 'activateAndBeginPandora activate fail');
        callback(IdlAigcServiceImpl.FAIL);
        return;
      }
      const themeConfigDirPath: string = sandBoxPath + '/' + themeId;
      let res: boolean = await this.refactorConfig(configDir, themeConfigDirPath, configJson);
      if (!res) {
        Log.error(TAG, 'activateAndBeginPandora refactorConfig fail');
        callback(IdlAigcServiceImpl.FAIL);
        return;
      }
      this.requestImage(themeId, configJson.url, uid, token, algParam, (errCode: number, retVal: string): void => {
        if (errCode === IdlAigcServiceImpl.FAIL) {
          Log.error(TAG, `activateAndBeginPandora requestImage fail, Error: ${retVal}`);
          callback(IdlAigcServiceImpl.FAIL);
          return;
        }
        AigcNotificationManager.getInstance().sendNotice(themeId, AigcNoticeType.EXECUTING,
          this.notificationConfig);
        callback(IdlAigcServiceImpl.SUCCESS);
      });
    } catch (error) {
      Log.error(TAG, `activateAndBeginPandora Error: ${error?.code}, ${error?.message}`);
      callback(IdlAigcServiceImpl.FAIL);
    }
  }

  private async activateNewTheme(presetPath: string, tmpThemePath: string, isApplyToMain?: boolean,
    isApplyToCover?: boolean): Promise<string> {
    Log.info(TAG, `activateNewTheme start isApplyToMain:${isApplyToMain} isApplyToCover:${isApplyToCover}`);
    if (!AigcFileUtils.isFileExists(presetPath) || !AigcFileUtils.isFileExists(tmpThemePath)) {
      Log.error(TAG, 'activateNewTheme path invalid');
      return '';
    }
    try {
      let res: boolean = false;
      // if (DeviceHelper.isNexSmallFold() && isApplyToMain && !isApplyToCover) {
      if ( isApplyToMain && !isApplyToCover) {
        res = await TsRemoteCaller.getInstance(this.context)
          .activateThemeCustom(presetPath, tmpThemePath, undefined, true, isApplyToMain);
      } else {
        res = await TsRemoteCaller.getInstance(this.context).activateThemeCustom(presetPath, tmpThemePath);
      }
      if (!res) {
        Log.error(TAG, 'activateNewTheme activate failed');
        return '';
      }
      Log.info(TAG, 'activateNewTheme activateThemeCustom success');
      let currentTheme: NullableType<ThemeInfoNew> = await TsRemoteCaller.getInstance(this.context).getCurrentTheme();
      let themeId: string = currentTheme?.editorId ?? '';
      if (!themeId) {
        Log.error(TAG, 'activateNewTheme getCurrentTheme fail');
        return '';
      }
      Log.info(TAG, `activateNewTheme getCurrentTheme: ${themeId}`);
      return themeId;
    } catch (e) {
      Log.error(TAG, `activateNewTheme fail: ${e?.code}, ${e?.message}`);
      return '';
    }
  }

  // private getPandoraConfig(configDirPath: string): PandoraConfig | undefined {
  private getPandoraConfig(configDirPath: string): ESObject | undefined {
    Log.info(TAG, 'getPandoraConfig start');
    if (!AigcFileUtils.isFileExists(configDirPath)) {
      Log.error(TAG, 'getPandoraConfig fail, configDirPath not exists');
      return;
    }
    const configPath: string = configDirPath + '/config.json';
    const configStr: string = AigcFileUtils.getStringByFile(configPath);
    if (configStr.length === 0) {
      Log.error(TAG, 'getPandoraConfig read config file fail');
      return;
    }
    // let configJson: PandoraConfig = new PandoraConfig();
    let configJson: ESObject;
    try {
      // configJson = JSON.parse(configStr) as PandoraConfig;
      configJson = JSON.parse(configStr) as ESObject;
    } catch (parseError) {
      Log.error(TAG, `getPandoraConfig JSON.parse Error: ${parseError?.code}, ${parseError?.message}`);
      return;
    }
    Log.info(TAG, 'getPandoraConfig success');
    return configJson;
  }

  private async refactorConfig(
    // configDirPath: string, themeConfigDirPath: string, configJson: PandoraConfig
    configDirPath: string, themeConfigDirPath: string, configJson: ESObject
  ): Promise<boolean> {
    Log.info(TAG, 'refactorConfig start');
    if (!AigcFileUtils.isFileExists(configDirPath)) {
      Log.error(TAG, `refactorConfig path invalid`);
      return false;
    }
    try {
      AigcFileUtils.copyDirectory(configDirPath, themeConfigDirPath);
      fs.rmdirSync(configDirPath);
      Log.info(TAG, 'refactorConfig moveDirSync success');
      const themeConfigPath: string = themeConfigDirPath + '/config.json';
      let url: string = themeConfigDirPath + '/pandora.jpg';
      if (!AigcFileUtils.isFileExists(url)) {
        Log.error(TAG, 'refactorConfig pandora url not exists');
        return false;
      }
      Log.info(TAG, 'refactorConfig pandora resource exists');
      configJson.url = url;
      let fileSaveRes: boolean = await AigcFileUtils.createFileWithJsonObject(themeConfigPath, configJson);
      if (!fileSaveRes) {
        Log.error(TAG, 'refactorConfig createFileWithJsonObject fail');
        return false;
      }
      Log.info(TAG, 'refactorConfig success');
      return true;
    } catch (e) {
      Log.error(TAG, `refactorConfig failed, Error: ${e?.code}, ${e?.message}`);
      return false;
    }
  }
}