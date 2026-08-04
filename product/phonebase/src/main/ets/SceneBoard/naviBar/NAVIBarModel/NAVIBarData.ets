/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { GlobalContext, SystemParamUtils, WallpaperManager, WallpaperType } from '@ohos/frameworkwrapper';
import { NAVIBarConstants, scbGestureManager } from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { uniformTypeDescriptor } from '@kit.ArkData';
import { SCBNaviBarConstants } from '../SCBNaviBarConstants';
import { TouchEvent as InputTouch } from '@ohos.multimodalInput.touchEvent';
import { naviBarSettingsDataMgr, NaviBarSettingsDataMgr } from '../settings/preference/NaviBarSettingsDataMgr';
import { image } from '@kit.ImageKit';
import { effectKit } from '@kit.ArkGraphics2D';
import { BusinessError } from '@kit.BasicServicesKit';
import { SystemSceneConstants } from '../../gesturenavigation/SystemSceneConstants';
import { NAVIBarViewData } from './NAVIBarViewData';
import { DragEventType } from '../../gesturenavigation/SCBGestureNavBarViewModel';
import { SCBVisualEffectMgr } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { VisualEffectConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { display } from '@kit.ArkUI';
import { gestureNavBarSettings } from '@ohos/gesturenavigation/src/main/ets/GestureNavBarSettings';
// import { hdsEffect } from '@kit.UIDesignKit';

const TAG = 'NAVIBarData';
const NAV_BAR_TAG = 'SCBGestureNavBar';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export class NAVIBarData {
  private static mInstance: NAVIBarData;
  public isDesktopDrag: boolean = false;
  public desktopDragItemInfo: GridLayoutItemInfo | undefined = undefined;
  public desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  public is2DRelease: boolean = SystemParamUtils.isHddProduct();
  public isNaviBarRetract: boolean = false;
  public startPosition: number = 0;
  public lastTouchEvent: InputTouch | null = null;
  public stopTimeStamp: number = 0;
  public shadowColor: ResourceStr = SCBNaviBarConstants.SHADOW_COLOR_START;
  public naviBarSettingsDataMgr: NaviBarSettingsDataMgr = naviBarSettingsDataMgr;
  public navBarDisappearWithStatusBar: number | null = null;
  public eventNaviBarStatusChange: number | null = null;
  public gameStatusMap: Map<string, number> = new Map();
  public naviBarWidth: number = SystemSceneConstants.BAR_DEFAULT_WIDTH;
  public viewController: BaseViewController = new BaseViewController(NAV_BAR_TAG);
  public naviBarAllowDropType: uniformTypeDescriptor.UniformDataType[] = [];
  public isNaviBarExistWhenDragStart: boolean = false;
  public desktopBrightnessOptions: BrightnessOptions = SCBNaviBarConstants.BRIGHTNESS_OPTIONS_TYPE1;
  public screenLockBrightnessOptions: BrightnessOptions = SCBNaviBarConstants.BRIGHTNESS_OPTIONS_TYPE1;
  public currentGestureNAVIBarType: number = NAVIBarConstants.GESTURE_NAVI_BAR_TYPE_DESKTOP;
  public lastTouchScreenY: number = 0;
  public inputMonitorNotifyCount: number = 0;
  public capsuleHeightPx: number = 0;
  public capsuleWidthPx: number = 0;
  public isInResetNaviBar: boolean = false;
  // 2s后隐藏导航条计时器
  public hideNaviBarTimer: number = 0;
  // 计时器是否停止计时
  public isTimerRunning: boolean = false;
  public immerseHideNaviBarTimer: number = 0;
  public naviBarPureColorMode: boolean = this.getNAVIBarPureColorMode();
  public windowHeight: number = Math.floor(vp2px(SystemSceneConstants.DEFAULT_HEIGHT));
  public dragEventValue: DragEventType = DragEventType.INIT;
  // 跟手参数
  public startOffsetY: number = 0;
  public startOffsetX: number = 0;
  public opacityAnimThresholdX = SystemSceneConstants.OPACITY_ANIM_DEFAULT_THRESHOLD_X;
  public isOpacityHideAnimStarted = false;
  public isOpacityShowAnimStarted = false;
  // 2S主动隐藏标记
  public isAppHide: boolean = false;
  // 当前屏幕展示类型
  public foldDisplayMode: display.FoldDisplayMode = display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  // 是否标记了游戏内
  public isInGameSign: boolean = false;
  static getInstance(): NAVIBarData {
    if (NAVIBarData.mInstance == null) {
      NAVIBarData.mInstance = new NAVIBarData();
    }
    return NAVIBarData.mInstance;
  }

  /**
   * 计算桌面与锁屏的导航条色彩参数
   * @param isDark 深色模式
   * @param screenWidth 当前屏幕宽度
   * @param screenHeight 当前屏幕高度
   */
  public async notifyWallpaperDarkeness(isDark: boolean, screenWidth: number, screenHeight: number) {
    try {
      let desktopWallpaper = await WallpaperManager.getInstance().getWallpaperCache(WallpaperType.DESKTOP, TAG);
      let desktopL = await this.getLightByImage(desktopWallpaper, screenWidth, screenHeight);
      let screenLockL = 0;
      let screenLockWallpaper = await WallpaperManager.getInstance().getWallpaperCache(WallpaperType.SCEENLOCK, TAG);
      screenLockL = await this.getLightByImage(screenLockWallpaper, screenWidth, screenHeight);
      log.showInfo(`isDark: ${isDark}`);
      if (!isDark) {
        // 这里的210和90都是UX定的，导航区域图片敏感值的分界点，当锁屏手电筒区域的颜色为亮时为210，暗时为90
        if (desktopL <= 210) {
          this.desktopBrightnessOptions = SCBNaviBarConstants.BRIGHTNESS_OPTIONS_TYPE1;
        } else {
          this.desktopBrightnessOptions = SCBNaviBarConstants.BRIGHTNESS_OPTIONS_TYPE2;
        }
        if (screenLockL <= 210) {
          this.screenLockBrightnessOptions = SCBNaviBarConstants.BRIGHTNESS_OPTIONS_TYPE1;
        } else {
          this.screenLockBrightnessOptions = SCBNaviBarConstants.BRIGHTNESS_OPTIONS_TYPE2;
        }
      } else {
        if (desktopL > 90) {
          this.desktopBrightnessOptions = SCBNaviBarConstants.BRIGHTNESS_OPTIONS_TYPE3;
        } else {
          this.desktopBrightnessOptions = SCBNaviBarConstants.BRIGHTNESS_OPTIONS_TYPE4;
        }
        if (screenLockL > 90) {
          this.screenLockBrightnessOptions = SCBNaviBarConstants.BRIGHTNESS_OPTIONS_TYPE3;
        } else {
          this.screenLockBrightnessOptions = SCBNaviBarConstants.BRIGHTNESS_OPTIONS_TYPE4;
        }
      }
      scbGestureManager.naviBarChange(this.currentGestureNAVIBarType);
    } catch (error) {
      log.showError('notifyWallpaperDarkeness is fail');
    }
  }

  private async getLightByImage(image: image.PixelMap, screenWidth: number, screenHeight: number): Promise<number> {
    let wallpaperWidth = 0;
    let wallpaperHeight = 0;
    await image.getImageInfo().then((info: image.ImageInfo) => {
      wallpaperWidth = info.size.width;
      wallpaperHeight = info.size.height;
      log.showInfo('info.width = ' + info.size.width);
      log.showInfo('info.height = ' + info.size.height);
    }).catch((err: BusinessError) => {
      log.showInfo(`Failed to obtain the image pixel map information.And the error code is: ${err.code}`);
    });
    const scaleWidth: number = wallpaperWidth / Math.max(1, screenWidth);
    const scaleHeight: number = wallpaperHeight / Math.max(1, screenHeight);
    // 导航条在壁纸上的左上角位置
    const imagePositionX: number = (wallpaperWidth - vp2px(this.naviBarWidth) * scaleWidth) / 2;
    const imagePositionY: number = wallpaperHeight - vp2px(SCBNaviBarConstants.CAPSULE_HEIGHT_INIT +
      gestureNavBarSettings.getNaviBarMarginBottom() + 1) * scaleHeight;
    // 导航条在壁纸上的宽高
    const imageSizeWidth: number = vp2px(this.naviBarWidth) * scaleWidth;
    const imageSizeHeight: number = vp2px(SCBNaviBarConstants.CAPSULE_HEIGHT_INIT + 2) * scaleHeight;
    // 调整成算式
    const xStart: number = imagePositionX / wallpaperWidth;
    const xEnd: number = (imagePositionX + imageSizeWidth) / wallpaperWidth;
    const yStart: number = imagePositionY / wallpaperHeight;
    const yEnd: number = (imagePositionY + imageSizeHeight) / wallpaperHeight;
    let colorPicker = await effectKit.createColorPicker(image, [xStart, yStart, xEnd, yEnd]);
    let color = colorPicker.getAverageColor();
    let L = 0.299 * color.red + 0.587 * color.green + 0.114 * color.blue;
    log.showInfo(`getWallpaper L:${L}, xStart:${xStart}, yStart:${yStart}, xEnd:${xEnd}, yEnd:${yEnd}`);
    return L;
  }

  public allDropType(): uniformTypeDescriptor.UniformDataType[] {
    let dropType: uniformTypeDescriptor.UniformDataType[] = [];
    Object.keys(uniformTypeDescriptor.UniformDataType).forEach(key => {
      dropType.push(uniformTypeDescriptor.UniformDataType[key])
    });
    return dropType;
  }

  /*
   * 通过是否DELIVER，温度，是否应用内，省电模式共同判断导航条颜色模式
   *
   * @returns 导航条颜色模式
   */
  public getNAVIBarColor(naviBarViewData: NAVIBarViewData): BrightnessOptions | ResourceColor | undefined {
    log.showInfo(`getNAVIBarColor scenePanelState is: ${naviBarViewData.scenePanelState},
      specialScenePanelState is: ${naviBarViewData.specialScenePanelState}`);
    // 如果导航条处于桌面或锁屏，导航条使用brightnessOptions（提亮压暗）控制颜色。
    // 如果应用内处于低功耗或过热模式，使用纯色，其他时候使用systemBarEffect
    // deliver应用也使用纯色
    if (naviBarViewData.isInFullScreen()) {
      if (naviBarViewData.isNeedToUsePureColor()) {
        return SCBNaviBarConstants.LOW_POWER_NAVIBAR_COLOR;
      } else {
        return undefined;
      }
    } else {
      return naviBarViewData.brightnessOptions;
    }
  }

  private getNAVIBarPureColorMode(): boolean {
    let naviBarPureColorMode = false;
    try {
      naviBarPureColorMode =
        SCBVisualEffectMgr.getFeatureParam(VisualEffectConstants.NAVIBAR_BLUR_INVERT_EFFECT_DISABLE) === 'true';
      log.showInfo(`getNAVIBarPureColorMode, read config file success, naviBarPureColorMode is : ${naviBarPureColorMode}`);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      log.showWarn(`getNAVIBarPureColorMode, read config file failed, error code: ${code}, message: ${message}`);
    }
    return naviBarPureColorMode;
  }
}