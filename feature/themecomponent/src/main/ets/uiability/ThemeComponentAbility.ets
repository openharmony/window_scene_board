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
import { BusinessError, commonEventManager, emitter, settings } from '@kit.BasicServicesKit';
import { Configuration } from '@ohos.app.ability.Configuration';
import { ThemeComponentConstant } from '../utils/ThemeComponentConstant';
import { AigcParams } from './AigcAbility';
import { Log } from '../aigcServiceAbility/IdlService/Log';
import { ThemeInfoAdapter } from '../themeInfoAdapter/ThemeInfoAdapter';
import { WallPaper, WallPaperInfo } from '@ohos/themeservicekit';

const TAG: string = 'ThemeEditor_ThemeComponentAbility';
const TRANSPARENT_COLOR: string = '#00000000';
const SCB_BUNDLE_NAME: string = 'com.ohos.sceneboard';
const NOTICE_PULL_UP_FINISH: string = 'PandoraPullUpFinished';
const PANDORA2_NEW_NOTICE: string = 'PANDORA2_NEW_NOTICE';

export default class ThemeComponentAbility extends UIAbility {
  private navName: string = '';
  private isFull: boolean = false;
  private isEligible: boolean = false;
  private url: string = '';
  private isImageAesthetic: boolean = false;
  private needResetClock: boolean = false;
  private path: string = ''; // 主题预览图路径
  private type: string = ''; // 主题预览图类型
  private currentIndex: number = 0; // 需要显示的主题预览图索引
  private editorId: string = '';
  private themeWindowStage: window.WindowStage | undefined;
  private thumbnail: string = ''; // 壁纸缩略图
  private startMode: number = -1;
  private currThemeId: string = '';
  private status: number = -1;
  private errCode: number = 0;

  /**
   * On ThemeComponentAbility ability instance create
   */
  onCreate(want: Want, _launchParam: AbilityConstant.LaunchParam): void {
    Log.info(TAG, 'onCreate')
    this.setEmitter();
    this.publishNoticePullUp();
    // GlobalContext.getContext().setObject(Constants.THEME_EDITOR_CONTEXT, this.context);
    // ThumbnailManager.getInstance(this.context);
    if (want?.parameters) {
      const callerBundleName: string | undefined = want.parameters['ohos.aafwk.param.callerBundleName'] as string;
      if (callerBundleName && callerBundleName.length > 0 && callerBundleName !== SCB_BUNDLE_NAME) {
        Log.error(TAG, `onCreate: ineligible caller ${callerBundleName} for this activity, terminate,terminateSelf in file:ThemeComponentAbility>onCreate`);
        try {
          this.context?.terminateSelf();
        } catch (err) {
          Log.error(TAG, `terminateSelf error ${err}`);
        }
        return;
      }
      Log.debug(TAG, 'onCreate para:', want.parameters);
      this.navName = want.parameters[ThemeComponentConstant.NAV_NAME] as string;
      this.isFull = want.parameters[ThemeComponentConstant.IS_FULL_SCREEN] as boolean;
      this.url = want.parameters[ThemeComponentConstant.IMAGE_URL] as string;
      this.isImageAesthetic = want.parameters[ThemeComponentConstant.IS_NEED_AESTHETIC] as boolean;
      this.needResetClock = want.parameters['needResetClock'] as boolean;
      this.isEligible = true;
      this.path = want.parameters['path'] as string;
      this.type = want.parameters['type'] as string;
      this.currentIndex = want.parameters['currentIndex'] as number;
      this.editorId = want.parameters['editorId'] as string;
      this.thumbnail = want.parameters['thumbnail'] as string;
      this.startMode = want.parameters['startMode'] as number;
      this.currThemeId = want.parameters['editorId'] as string;
      this.status = want.parameters['status'] as number;
      this.errCode = want.parameters['errCode'] as number;

      //ThemeInfoAdapter测试
      let themeInfoAdapter: ThemeInfoAdapter = new ThemeInfoAdapter(this.context);
      let wallPaper: WallPaper = {
        src: this.url,
        contentType: 'image',
        category: 'base'
      };
      let wallPaperInfo: WallPaperInfo = {
        wallPapers: [wallPaper],
        wallPaperType: 'home',
        type: 'image'
      }
      let wallPaperInfos: WallPaperInfo[] = [wallPaperInfo]
      themeInfoAdapter.setWallpaper(wallPaperInfos)
    } else {
      Log.error(TAG, 'onCreate: no para');
    }
  }

  private setEmitter(): void {
    emitter.on(PANDORA2_NEW_NOTICE, (eventData: emitter.EventData) => {
      let themeId: string = eventData?.data?.['themeId'] as string ?? '';
      Log.info(TAG, `themeId ${themeId} currThemeId ${this.currThemeId}`);
      if (themeId !== '' && this.currThemeId !== themeId) {
        this.context.terminateSelf();
      }
    });
  }

  /**
   * On ThemeComponentAbility ability instance destroy
   */
  onDestroy(): void {
    Log.info(TAG, 'onDestroy');
    // GlobalContext.getContext().removeObject(Constants.THEME_EDITOR_CONTEXT);
    // ThumbnailManager.getInstance(this.context).cancelOngoingTasks();
    emitter.off(PANDORA2_NEW_NOTICE);
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Log.info(TAG, 'onNewWant');
    this.publishNoticePullUp();
    if (want?.parameters) {
      const callerBundleName: string | undefined = want.parameters['ohos.aafwk.param.callerBundleName'] as string;
      if (callerBundleName && callerBundleName.length > 0 && callerBundleName !== SCB_BUNDLE_NAME) {
        Log.error(TAG, `onCreate: ineligible caller ${callerBundleName} for this activity`);
        return;
      }
      if (this.isPandora2Scene(want)) {
        Log.info(TAG, 'Pandora2 Scene');
        return;
      }
      Log.debug(TAG, 'onNewWant para:', want.parameters);
      this.navName = want.parameters[ThemeComponentConstant.NAV_NAME] as string;
      this.isFull = want.parameters[ThemeComponentConstant.IS_FULL_SCREEN] as boolean;
      this.url = want.parameters[ThemeComponentConstant.IMAGE_URL] as string;
      this.isImageAesthetic = want.parameters[ThemeComponentConstant.IS_NEED_AESTHETIC] as boolean;
      this.isEligible = true;
      this.path = want.parameters['path'] as string;
      this.type = want.parameters['type'] as string;
      this.needResetClock = want.parameters['needResetClock'] as boolean;
      this.currentIndex = want.parameters['currentIndex'] as number;
      this.editorId = want.parameters['editorId'] as string;
      this.thumbnail = want.parameters['thumbnail'] as string;
    } else {
      Log.error(TAG, 'onNewWant: no para');
    }
    // let params: WantParams = {
    let params: ESObject = {
      nav: this.navName,
      isFull: this.isFull,
      url: this.url,
      imageAesthetic: this.isImageAesthetic,
      path: this.path,
      type: this.type,
      currentIndex: this.currentIndex,
      needResetClock: this.needResetClock,
      editorId: this.editorId,
      thumbnail: this.thumbnail,
    };
    // let para: Record<string, WantParams> = { 'params': params };
    let para: Record<string, ESObject> = { 'params': params };
    let storage: LocalStorage = new LocalStorage(para);
    this.themeWindowStage?.loadContent('pages/ThemeHome', storage);
  }

  private isPandora2Scene(want: Want): boolean {
    if (want?.parameters) {
      let startMode: number = want.parameters['startMode'] as number;
      if (!startMode) {
        Log.info(TAG, 'is not Pandora2Scene');
        return false;
      }
      let editorId: string = want.parameters['editorId'] as string;
      let status: number = want.parameters['status'] as number;
      let errCode: number = want.parameters['errCode'] as number;
      let skipLoad: boolean = this.startMode === startMode && this.currThemeId === editorId && this.status === status &&
        this.errCode === errCode;
      if (skipLoad) {
        Log.info(TAG, `same param, not load content startMode: ${startMode}, editorId: ${editorId}, status: ${status}`);
        return true;
      }
      this.startMode = startMode;
      this.currThemeId = editorId;
      this.status = status;
      this.errCode = status;
      let params: AigcParams = {
        startMode: this.startMode,
        editorId: this.currThemeId,
        status: this.status,
        errCode: this.errCode
      };
      let para: Record<string, AigcParams> = { 'params': params };
      let storage: LocalStorage = new LocalStorage(para);
      this.themeWindowStage?.loadContent('pages/ThemeHome', storage);
      return true;
    }
    return false;
  }

  /**
   * On ThemeComponentAbility ability instance WindowStageCreate
   *
   * @param windowStage windowStage
   */
  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    Log.info(TAG, 'onWindowStageCreate');
    // GlobalContext.getContext().setObject('windowStage', windowStage);
    if (!this.isEligible) {
      return;
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
      this.registerFoldChangeListener()

      if (this.startMode && this.startMode !== -1 && this.currThemeId !== '') {
        Log.info(TAG, 'Pandora2 Scene');
        let params: AigcParams = {
          startMode: this.startMode,
          editorId: this.currThemeId,
          status: this.status,
          errCode: this.errCode
        };
        let para: Record<string, AigcParams> = { 'params': params };
        let storage: LocalStorage = new LocalStorage(para);
        // 加载主页面内容
        await windowStage.loadContent('pages/ThemeHome', storage);
      } else {
        // let params: WantParams = {
        let params: ESObject = {
          nav: this.navName,
          isFull: this.isFull,
          url: this.url,
          imageAesthetic: this.isImageAesthetic,
          path: this.path,
          type: this.type,
          currentIndex: this.currentIndex,
          needResetClock: this.needResetClock,
          editorId: this.editorId,
          thumbnail: this.thumbnail,
        };
        // let para: Record<string, WantParams> = { 'params': params };
        let para: Record<string, ESObject> = { 'params': params };
        let storage: LocalStorage = new LocalStorage(para);
        // 加载主页面内容
        await windowStage.loadContent('pages/ThemeHome', storage);
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

  private adjustOrientation(windowStage: window.WindowStage): void {
    try {
      // if (DeviceHelper.isPhone() && (!DeviceHelper.isFold() ||
      //   display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_FOLDED)) {
        windowStage.getMainWindow().then(windowInstance => {
          windowInstance.setPreferredOrientation(window.Orientation.PORTRAIT);
        })
        Log.info(TAG, 'orientation set to PORTRAIT.');
      // } else {
      //   Log.info(TAG, 'orientation set to AUTO_ROTATION_RESTRICTED.');
      //   windowStage.getMainWindow().then(windowInstance => {
      //     windowInstance.setPreferredOrientation(window.Orientation.AUTO_ROTATION_RESTRICTED);
      //   })
      // }
    } catch (e) {
      // Log.info(TAG, `set orientation error message: ${(e as BusinessError).message}`);
      windowStage.getMainWindow().then(windowInstance => {
        windowInstance.setPreferredOrientation(window.Orientation.PORTRAIT);
      });
    }
  }

  private async registerFoldChangeListener(): Promise<void> {
    try {
      display.on('foldStatusChange', (status: number) => {
        Log.info(TAG, `on fold status changed: ${status}`);
        if (status === display.FoldStatus.FOLD_STATUS_FOLDED) {
          this.themeWindowStage?.getMainWindow().then(windowInstance => {
            windowInstance.setPreferredOrientation(window.Orientation.PORTRAIT);
          });
        } else {
          this.themeWindowStage?.getMainWindow().then(windowInstance => {
            windowInstance.setPreferredOrientation(window.Orientation.AUTO_ROTATION_RESTRICTED);
          });
        }
      })
    } catch (e) {
      // Log.error(TAG, `${TAG} register foldStatusChange: ${(e as BusinessError).message}`);
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

  private publishNoticePullUp(): void {
    try {
      commonEventManager.publish(NOTICE_PULL_UP_FINISH, this.onNoticePullUpPublish);
    } catch (err) {
      Log.error(TAG, `Error on publishing ThemeFinishLoading event, code: ${err?.code}, msg: ${err?.message}`);
    }
  }
}
