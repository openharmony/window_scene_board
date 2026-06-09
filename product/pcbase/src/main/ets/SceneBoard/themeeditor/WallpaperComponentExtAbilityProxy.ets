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

import Want from '@ohos.app.ability.Want';
import { LogDomain, LogHelper, UIContextHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { promptAction, window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { PCUtils } from '../../common/utils/PCUtils';

const TAG: string = 'WallpaperComponentExtAbilityProxy';
const WINDOW_NAME: string = 'WallpaperComponentExtAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const WINDOW_BACKGROUND_COLOR: string = '#00000000'; // 窗口背景色
const WINDOW_WIDTH: number = 5;
const WINDOW_HEIGHT: number = 5;

export default class WallpaperComponentExtAbilityProxy {
  private static mInstance: WallpaperComponentExtAbilityProxy;

  public static getInstance(): WallpaperComponentExtAbilityProxy {
    if (!WallpaperComponentExtAbilityProxy.mInstance) {
      WallpaperComponentExtAbilityProxy.mInstance = new WallpaperComponentExtAbilityProxy();
    }
    return WallpaperComponentExtAbilityProxy.mInstance;
  }

  private src: string = '';
  private window: window.Window | undefined = undefined;
  private windowClosing: boolean = false;
  private displayId: string = '';

  // 更新资源、数据
  onCreate(want: Want) {
    log.showInfo(`onCreate`)
    if (want?.parameters) {
      this.src = want.parameters['router'] as string;
      this.displayId = want.parameters['displayId'] as string;
    } else {
      log.showError('onNewWant: no para');
    }
  }

  async onRequest(want: Want, context: common.ServiceExtensionContext) {
    if (await PCUtils.isModifyWallpaperDisable()) {
      log.showInfo(`modify wallpaper is disbaled,show toast`);
      try {
        promptAction.showToast({
          message: $r('app.string.disable_modify_wallpaper_tips')
        });
      } catch (e) {
        log.showError(`showToast fail, code: ${e?.code}, message: ${e?.message}`);
      }
      return;
    }
    try {
      log.showInfo('onRequest');
      if (want?.parameters) {
        this.src = want.parameters['router'] as string;
        this.displayId = want.parameters['displayId'] as string;
      } else {
        log.showError('onNewWant: no para');
      }
      this.window =
        await this.startFloatWindow(context, WINDOW_NAME, 'SceneBoard/themeeditor/pages/WallpaperApplyPage');
      this.windowClosing = false;
      // 监听主窗口外部点击事件
      this.window?.on('touchOutside', () => {
        context.terminateSelf();
      })
    } catch (err) {
      log.showError(`onRequest error and err is ${JSON.stringify(err)}}`);
    }
  }

  // 系统资源的释放、数据的保存等
  onDestroy() {
    log.showInfo('onDestroy');
    // 调用terminateSelf会走onDestroy回调, 销毁ability的同时关闭已定义的窗口
    this.closeFloatWindow(this.window);
  }

  public async startFloatWindow(context: common.ServiceExtensionContext, windowName: string, path: string):
    Promise<window.Window | undefined> {
    log.showInfo(`startFloatWindow: ${windowName}`);
    if (context == null) {
      log.showInfo(`createFloatWindow fail: param is invalid`);
      return undefined;
    }
    let config: window.Configuration = {
      name: 'WallpaperComponentExtAbility',
      windowType: window.WindowType.TYPE_FLOAT,
      ctx: context
    };
    log.showInfo(`startFloatWindow displayId ${this.displayId}`)
    if (Number(this.displayId)) {
      config.displayId = Number(this.displayId);
    }
    let screenWidth = AppStorage.get<number>('screenWidth') as number;
    let screenHeight = AppStorage.get<number>('screenHeight') as number;
    let windowClass: window.Window = await window.createWindow(config);
    const displayId: number = config.displayId ?? 0;
    try {
      // 加载的UI组件需要外窗承载，否则无法显示
      await windowClass.setUIContent(path);
      windowClass.setWindowBackgroundColor(WINDOW_BACKGROUND_COLOR);
      // 定义一个窗口，将其放在模态框背后
      await windowClass.resize(UIContextHelper.vp2px(displayId, WINDOW_WIDTH),
        UIContextHelper.vp2px(displayId, WINDOW_HEIGHT));
      AppStorage.setOrCreate<common.ServiceExtensionContext>('wallPaperContext', context);
      AppStorage.setOrCreate<string>('src', this.src);
      // 显示窗口
      await windowClass.showWithAnimation().then(() => {
        log.showInfo('show window is success');
      }).catch((err: BusinessError) => {
        log.showError(`showWithAnimation error and err is ${JSON.stringify(err)}}`);
      });
      // 将窗口移动到屏幕中间，被模态框挡住
      windowClass.moveWindowTo(UIContextHelper.vp2px(displayId, screenWidth) / 2,
        UIContextHelper.vp2px(displayId, screenHeight) / 2).then(() => {
        log.showInfo('moveWindowTo is success');
      }).catch((err: BusinessError) => {
        log.showError(`moveWindowTo error and err is ${JSON.stringify(err)}}`);
      });
    } catch (err) {
      log.showError(`startFloatWindow error and err is ${JSON.stringify(err)}}`);
    }
    return windowClass;
  }

  public async closeFloatWindow(window: window.Window | undefined) {
    if (window && !this.windowClosing) {
      log.showInfo('closeFloatWindow start');
      this.windowClosing = true;
      try {
        await window.hideWithAnimation().then(() => {
          log.showInfo('hide window is success');
        }).catch((err: BusinessError) => {
          log.showError(`hideWithAnimation error and err is ${JSON.stringify(err)}}`);
        });
        await window.destroyWindow().then(() => {
          log.showInfo('destroy window is success');
        }).catch((err: BusinessError) => {
          log.showError(`destroyWindow error and err is ${JSON.stringify(err)}}`);
        });
      } catch (err) {
        log.showError(`closeFloatWindow error and err is ${JSON.stringify(err)}}`);
      }
    }
  }
}