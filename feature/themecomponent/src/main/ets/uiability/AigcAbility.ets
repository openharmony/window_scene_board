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

import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import { display } from '@kit.ArkUI';
import { BusinessError, commonEventManager, settings } from '@kit.BasicServicesKit';
import { Configuration } from '@ohos.app.ability.Configuration';
import { Log } from '../aigcServiceAbility/IdlService/Log';

const TAG: string = '[AigcService]AigcAbility';
const TRANSPARENT_COLOR: string = '#00000000';
const SCB_BUNDLE_NAME: string = 'com.ohos.sceneboard';
const NOTICE_PULL_UP_FINISH: string = 'PandoraPullUpFinished';
const AIGC_VERSION: string = 'V2';

export interface AigcParams {
  startMode?: number;
  path?: string;
  editorId?: string; // 主题的editorId
  status?: number; // 潘多拉主题生成结果
  errCode?: number; // 生成失败的错误码
  pushPathName?: string; // NavPathStack pushPathName
}

export default class AigcAbility extends UIAbility {
  private startMode: number = -1;
  private editorId: string = '';
  private status: number = -1;
  private errCode: number = 0;
  private loadContent: string = '';
  private pushPathName: string = '';
  private themeWindowStage: window.WindowStage | undefined;
  private version: string = '';
  private windowStageChangeCallback: Callback<window.WindowStageEventType> = (data: window.WindowStageEventType) => {
    if (data == window.WindowStageEventType.PAUSED) {
      Log.info(TAG, 'onWindowStageCreate window.WindowStageEventType.PAUSED');
      // 进入多任务，转为不可交互状态
      this.context?.terminateSelf();
    }
  }

  /**
   * On AigcParams ability instance create
   */
  onCreate(want: Want, _launchParam: AbilityConstant.LaunchParam): void {
    Log.info(TAG, 'onCreate');
    // GlobalContext.getContext().setObject(Constants.THEME_EDITOR_CONTEXT, this.context);
    // ThumbnailManager.getInstance(this.context);
    if (want?.parameters) {
      const callerBundleName: string | undefined = want.parameters['ohos.aafwk.param.callerBundleName'] as string;
      if (callerBundleName && callerBundleName.length > 0 && callerBundleName !== SCB_BUNDLE_NAME) {
        Log.error(TAG, `onCreate: ineligible caller ${callerBundleName} for this activity, terminate,terminateSelf
          in file:AigcAbility>onCreate`);
        try {
          this.context?.terminateSelf();
        } catch (err) {
          Log.error(TAG, `terminateSelf error ${err}`);
        }
        return;
      }
      Log.debug(TAG, 'onCreate para:', want.parameters);
      this.startMode = want.parameters['startMode'] as number;
      this.editorId = want.parameters['editorId'] as string;
      this.status = want.parameters['status'] as number;
      this.errCode = want.parameters['errCode'] as number;
      this.version = want.parameters['version'] as string;
      this.loadContent = want.parameters['loadContent'] as string;
      let noticePullUp = want.parameters['noticePullUp'] as string;
      this.pushPathName = want.parameters['pushPathName'] as string;
      this.publishNoticePullUp(noticePullUp);
    } else {
      Log.error(TAG, 'onCreate: no para');
    }
  }

  /**
   * On AigcAbility ability instance destroy
   */
  onDestroy(): void {
    Log.info(TAG, 'onDestroy');
    // GlobalContext.getContext().removeObject(Constants.THEME_EDITOR_CONTEXT);
    // ThumbnailManager.getInstance(this.context).cancelOngoingTasks();
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Log.info(TAG, 'onNewWant');
    if (want?.parameters) {
      const callerBundleName: string | undefined = want.parameters['ohos.aafwk.param.callerBundleName'] as string;
      if (callerBundleName && callerBundleName.length > 0 && callerBundleName !== SCB_BUNDLE_NAME) {
        Log.error(TAG, `onCreate: ineligible caller ${callerBundleName} for this activity`);
        return;
      }
      Log.debug(TAG, 'onNewWant para:', want.parameters);
      let startMode: number = want.parameters['startMode'] as number;
      let editorId: string = want.parameters['editorId'] as string;
      let status: number = want.parameters['status'] as number;
      let errCode: number = want.parameters['errCode'] as number;
      let loadContent: string = want.parameters['loadContent'] as string;
      let noticePullUp: string = want.parameters['noticePullUp'] as string;
      let pushPathName: string = want.parameters['pushPathName'] as string;
      this.publishNoticePullUp(noticePullUp);
      let version: string = want.parameters['version'] as string;
      let skipLoad: boolean = this.startMode === startMode && this.editorId === editorId && this.status === status &&
        this.errCode === errCode && version !== AIGC_VERSION;
      if (skipLoad) {
        Log.info(TAG, `same param, not load content startMode: ${startMode}, editorId: ${editorId}, status: ${status}`);
        return;
      }
      this.startMode = startMode;
      this.editorId = editorId;
      this.status = status;
      this.errCode = errCode;
      this.pushPathName = pushPathName;
      let params: AigcParams = {
        startMode: this.startMode,
        editorId: this.editorId,
        status: this.status,
        errCode: this.errCode,
        pushPathName: this.pushPathName
      };
      let para: Record<string, AigcParams> = {
        'params': params
      };
      let storage: LocalStorage = new LocalStorage(para);
     if (this.version === AIGC_VERSION) {
        this.themeWindowStage?.loadContent('pages/ThemeHome', storage);
      } else {
        this.themeWindowStage?.loadContent(loadContent, storage);
        Log.error(TAG, 'onNewWant: no para');
      }
    }
  }

  /**
   * On AigcAbility ability instance WindowStageCreate
   *
   * @param windowStage windowStage
   */
  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    Log.info(TAG, 'onWindowStageCreate');
    // 通知上滑进入多任务不显示，要直接terminate，不然会一直占用内存
    try {
      windowStage.on('windowStageEvent', this.windowStageChangeCallback);
    } catch (exception) {
      Log.error(TAG, 'onWindowStageCreate create windowStageEvent failed');
    }

    let fontScale: number = 1.0;
    try {
      fontScale = Number(settings.getValueSync(this.context, 'font_scale', '1', settings.domainName.USER_PROPERTY));
    } catch (e) {
      Log.error(TAG, 'get font_scale error');
    }
    // fontScaleManager.setSysFontScale(fontScale);
    try {
      this.adjustOrientation(windowStage);
      this.themeWindowStage = windowStage;

      let params: AigcParams = {
        startMode: this.startMode,
        editorId: this.editorId,
        status: this.status,
        errCode: this.errCode,
        pushPathName: this.pushPathName
      };
      let para: Record<string, AigcParams> = {
        'params': params
      };
      let storage: LocalStorage = new LocalStorage(para);

      // 加载主页面内容
      if (this.version === AIGC_VERSION) {
        await windowStage?.loadContent('pages/ThemeHome', storage);
      } else {
        await windowStage?.loadContent(this.loadContent, storage);
      }

      // 获取主窗口
      windowStage.getMainWindow()
        .then((win: window.Window) => {
          // 隐藏状态栏和导航条,设置应用window背景颜色为透明
          win.setWaterMarkFlag(true);
          win.setWindowLayoutFullScreen(true);
          win.setWindowBackgroundColor(TRANSPARENT_COLOR);
        })
    } catch (err) {
      if (err.code) {
        Log.info(TAG, 'Failed to load the content. Code: %{public}d', err.code);
      }
    }
  }

  onWindowStageWillDestroy(windowStage: window.WindowStage): void {
    Log.info(TAG, 'onWindowStageWillDestroy');
    try {
      windowStage.off('windowStageEvent', this.windowStageChangeCallback);
    } catch (exception) {
      Log.error(TAG, 'onWindowStageWillDestroy remove windowStageEvent failed');
    }
  }

  private adjustOrientation(windowStage: window.WindowStage): void {
    try {
      // if (DeviceHelper.isPhone() && (!DeviceHelper.isFold() || DeviceHelper.isNexSmallFold())) {
      //   windowStage.getMainWindow().then(windowInstance => {
      //     windowInstance.setPreferredOrientation(window.Orientation.PORTRAIT);
      //   })
      //   Log.info(TAG, 'orientation set to PORTRAIT.');
      // } else if (DeviceHelper.isPhone() && DeviceHelper.isFold()) {
      //   windowStage.getMainWindow().then(windowInstance => {
      //     windowInstance.setPreferredOrientation(window.Orientation.FOLLOW_DESKTOP);
      //   })
      //   Log.info(TAG, 'orientation set to FOLLOW_DESKTOP.');
      // } else {
      //   Log.info(TAG, 'orientation set to AUTO_ROTATION_RESTRICTED.');
      //   windowStage.getMainWindow().then(windowInstance => {
      //     windowInstance.setPreferredOrientation(window.Orientation.AUTO_ROTATION_RESTRICTED);
      //   })
      // }
    } catch (e) {
      Log.info(TAG, `set orientation error message: ${(e as BusinessError).message}`);
      windowStage.getMainWindow().then(windowInstance => {
        windowInstance.setPreferredOrientation(window.Orientation.PORTRAIT);
      });
    }
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    // fontScaleManager.setSysFontScale(newConfig.fontSizeScale || 1);
  }

  private onNoticePullUpPublish(err: BusinessError): void {
    if (err) {
      Log.error(TAG, `publishNoticePullUp failed, code: ${err.code}, message: ${err.message}`);
      return;
    }
    Log.info(TAG, `Succeeded publish event: ${NOTICE_PULL_UP_FINISH}`);
  }

  private publishNoticePullUp(noticePullUp: string): void {
    try {
      commonEventManager.publish(noticePullUp, this.onNoticePullUpPublish);
    } catch (err) {
      Log.error(TAG, `Error on publishing ThemeFinishLoading event, code: ${err?.code}, msg: ${err?.message}`);
    }
  }
}
