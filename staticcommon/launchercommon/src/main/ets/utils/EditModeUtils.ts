/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import systemParameter from '@ohos.systemparameter';
import { EventConstants } from '../constants/EventConstants';
import {
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { RectangularCoordinates, desktopUtil } from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import {
  DeviceHelper,
  localEventManager
} from '@ohos/frameworkwrapper';
import { DesktopMode, DeviceState } from '../constants/CommonConstants';
import EditModeConstants from './EditModeConstants';
import { editModeManager } from '../editmode/model/EditModeManager';
import { DeleteIconAreaParam } from '../editmode/data/DeleteIconAreaParam';
import {
  GridLayoutItemInfo,
  GridLayoutUtil,
  LayoutViewModel,
  OpenFolderStyleConfig,
  StyleConstants,
} from '../TsIndex';
import { folderLayoutUtil } from './FolderLayoutUtil';
import { FoldPhoneTypeValue } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';

/**
 * 系统参数：是否支持编辑模式
 */
const DESKTOP_EDIT_SUPPORT: string = 'scb.desktop.edit.support';
const TAG = 'EditModeUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class EditModeUtils {
  private static isPC: boolean = DeviceHelper.isPC();
  private static isPhone: boolean = DeviceHelper.isPhone();
  private static scaleCenterY: number = 0;
  private static outerPhoneIconSize: number = 52;
  private static outerIconSpace: number = 18;
  private static outerSinglePageFrame: number = 10;

  /**
   * coordinates 二维数组
   * 返回grid组件在编辑模式下的left、top、width、height
   * 第二个元素是折叠屏右侧的坐标(可选)
   * [[left, top, width, height], [left, top, width, height]]
   */
  private static coordinates: number[][] = [];
  private static isConfigSupportEditMode: boolean = EditModeUtils.getEditModeSupportFromConfig();
  private static swiperScale: number = 1;
  private static pageScale: number = 1;
  public static isSupportEditMode(): boolean {
    return EditModeUtils.isPhone && EditModeUtils.isConfigSupportEditMode;
  }

  public static isInEditMode(mode: DesktopMode): boolean {
    if (EditModeUtils.isPC) {
      return false;
    }
    return mode === DesktopMode.EDIT_MODE;
  }

  /**
   * 通知删除按钮热区范围变化
   *
   * @param leftHotAreaSize 删除按钮热区左侧范围
   * @param bottomHotAreaSize 删除按钮热区底部范围
   */
  public static notifyHotAreaChanged(leftHotAreaSize: number, bottomHotAreaSize: number): void {
    const hotAreaRect: DeleteIconAreaParam = new DeleteIconAreaParam();
    hotAreaRect.leftHotAreaSize = leftHotAreaSize;
    hotAreaRect.bottomHotAreaSize = bottomHotAreaSize;
    localEventManager.sendLocalEvent(EventConstants.EVENT_EDIT_MODE_START_DRAG_ITEM, hotAreaRect);
  }

  private static getEditModeSupportFromConfig(): boolean {
    let result: string = '';
    try {
      result = systemParameter.getSync(DESKTOP_EDIT_SUPPORT, 'true');
    } catch (error) {
      result = 'true';
    }
    return result === 'true';
  }

  public static getDesktopScale(): number {
    return editModeManager.isInEditMode() ? EditModeUtils.getPageScale() * EditModeUtils.getSwiperScale() : 1;
  }

  public static convertWithDesktopScale(itemScale: number): number {
    return itemScale * EditModeUtils.getDesktopScale();
  }

  /**
   * scale后的vp值恢复到正常状态
   * @param item
   * @returns
   */
  public static recoverWithDesktopScale(item: number): number {
    return item / EditModeUtils.getDesktopScale();
  }

  public static getScaleCenterY(): number {
    return EditModeUtils.scaleCenterY;
  }

   public static setScaleCenterY(centerY: number): void {
     EditModeUtils.scaleCenterY = centerY;
  }

  public static getCoordinates():number[][] {
    return EditModeUtils.coordinates;
  }

  public static setCoordinateParameters(coordinate: number[][]): void {
    EditModeUtils.coordinates = coordinate;
  }

  public static setSwiperScale(scale: number): void {
    EditModeUtils.swiperScale = scale;
  }

  public static setPageScale(scale: number): void {
    EditModeUtils.pageScale = scale;
  }

  public static getSwiperScale(): number {
    return EditModeUtils.swiperScale;
  }

  public static getPageScale(): number {
    return EditModeUtils.pageScale;
  }
  /**
   * 编辑模式x轴坐标转换
   * @param number
   * @return number
   */
  public static transformCoordinateX(x: number): number {
    const centerX = AppStorage.get<number>('screenWidth') as number / 2;
    x += (centerX - x) * (1 - EditModeUtils.getPageScale() * EditModeUtils.getSwiperScale());
    return x;
  }

  /**
   * 编辑模式y轴坐标转换
   * @param number
   * @return number
   */
  public static transformCoordinateY(y: number): number {
    let sysUITop: number = LayoutViewModel.getInstance().getSysUITopHeight();
    const centerY = EditModeUtils.scaleCenterY + sysUITop;
    // 第一次缩放
    y += (centerY - y) * (1 - EditModeUtils.swiperScale);
    let workSpaceHeight = GridLayoutUtil.getFloorVp(AppStorage.get<number>('workSpaceHeight') as number);
    workSpaceHeight += (centerY - workSpaceHeight) * (1 - EditModeUtils.swiperScale);
    // 第二次缩放
    y += (workSpaceHeight - y) * (1 - EditModeUtils.pageScale);
    return y;
  }

  /**
   * 获取字体放大倍数
   * @returns
   */
  public static getFontScale(fontSizeScale: number): number {
    return Math.min(fontSizeScale, EditModeConstants.MAX_FONT_SIZE_SCALE);
  }

  /**
   * 获取字体放大倍数
   * @returns
   */
  public static getAppFontScale(fontSizeScale: number): number {
    return Math.min(fontSizeScale, EditModeConstants.APP_NAME_MAX_FONT_SIZE_SCALE);
  }

  /**
   * 获取字体、行高使用大小（vp）
   * @param font 字体、行高
   * @returns
   */
  public static getScaleSize(font: Resource | number, fontSizeScale: number): string {
    if (typeof font === 'number') {
      return font * EditModeUtils.getFontScale(fontSizeScale) + 'vp';
    }
    return ResUtils.getNumber(font) * EditModeUtils.getFontScale(fontSizeScale) + 'vp';
  }

  /**
   * 获取字体、行高使用大小（vp）
   * @param font 字体、行高
   * @returns
   */
  public static getAppScaleSize(font: Resource | number, fontSizeScale: number): string {
    if (typeof font === 'number') {
      return font * EditModeUtils.getAppFontScale(fontSizeScale) + 'vp';
    }
    return ResUtils.getNumber(font) * EditModeUtils.getAppFontScale(fontSizeScale) + 'vp';
  }

  /**
   * 编辑模式下背板高度
   * @param screenHeight 屏幕高度
   * @param screenWidth 屏幕宽度
   * @param workSpaceHeight 工作区间高度
   * @returns 编辑模式下背板高度
   */
  public static getBackgroundHeight(screenHeight: number, screenWidth: number, workSpaceHeight: number): number {
    let addHeight: number = EditModeUtils.getBackplaneAddHeight() / EditModeUtils.calEditModeScale(screenWidth);
    let swiperHeight = workSpaceHeight - LayoutViewModel.getInstance().getSysUITopHeight();
    if (!DeviceHelper.isPhone()) {
      swiperHeight = swiperHeight * (screenHeight - StyleConstants.SMART_DOCK_MARGIN_TOP) / screenHeight;
    }
    return swiperHeight + addHeight;
  }

  /**
   * 编辑模式下背板尺寸
   *
   * @param screenHeight 屏幕高度
   * @param screenWidth 屏幕宽度
   * @param workSpaceHeight 工作区间高度
   * @returns 编辑模式下背板高度
   */
  public static getOuterBackgroundSize(screenWidth?: number): number {
    if (!screenWidth) {
      screenWidth = AppStorage.get<number>('screenWidth') as number;
    }
    let outerSwiperSize = EditModeUtils.outerPhoneIconSize * 4 + EditModeUtils.outerIconSpace * 3 +
      EditModeUtils.outerSinglePageFrame * 2 / EditModeUtils.calEditModeScale(screenWidth);
    return outerSwiperSize;
  }

  /**
   * 编辑模式下背板圆角
   *
   * @param screenWidth 屏幕宽度
   * @returns 编辑模式下背板圆角
   */
  public static getBgBorderRadius(screenWidth: number, isOuter?: boolean): number {
    if (isOuter) {
      return EditModeConstants.OUTER_EDIT_MODE_BORDER_RADIUS / EditModeUtils.calEditModeScale(screenWidth);
    } else {
      return editModeManager.getEditModeStyleConfig().editModeBorderRadius / EditModeUtils.calEditModeScale(screenWidth);
    }
  }

  /**
   * 编辑模式下背板补充的高度
   * @returns 背板补充的高度
   */
  public static getBackplaneAddHeight(): number {
    let add = editModeManager.getEditModeStyleConfig().swiperEditAddHeight;
    if (DeviceHelper.isPad()) {
      add = DeviceHelper.isLandscape() ? EditModeConstants.SWIPER_ADD_HEIGHT_PAD_LANDSCAPE :
      EditModeConstants.SWIPER_ADD_HEIGHT_PAD;
    }
    return add;
  }

  /**
   * 获取Swiper的prevMargin,NextMargin
   * @returns Swiper的prevMargin,NextMargin
   */
  public static getPrevNextMargin(isOuterDesktop: boolean = launcherStatusUtil.getShowOutLauncherStatus()): number {
    let prevNextMargin: number = 0;
    if (DeviceHelper.isPad() && DeviceHelper.isLandscape()) {
      prevNextMargin = EditModeUtils.recoverWithDesktopScale(EditModeConstants.SWIPER_PREV_NEXT_MARGIN_PAD);
    } else {
      prevNextMargin = isOuterDesktop ? EditModeConstants.OUTER_PREV_NEXT_MARGIN :
      editModeManager.getEditModeStyleConfig().swiperPrevNextMargin;
    }
    return prevNextMargin;
  }

  /**
   * 编辑模式的缩放值
   * @param screenWidth 屏幕宽度
   * @returns 编辑模式的缩放值
   */
  public static calEditModeScale(screenWidth: number): number {
    return EditModeUtils.calSwiperScale(screenWidth) * EditModeUtils.calSinglePageScale(screenWidth);
  }

  /**
   * SinglePage的缩放值
   * @param screenWidth 屏幕宽度
   * @returns SinglePage的缩放值
   */
  public static calSinglePageScale(screenWidth: number): number {
    let pageWidth = screenWidth - EditModeUtils.getPrevNextMargin();
    let swiperEditScaleRate = editModeManager.getEditModeStyleConfig().swiperEditScaleRate;
    let editModePageScale = pageWidth * swiperEditScaleRate / (pageWidth * swiperEditScaleRate +
    editModeManager.getEditModeStyleConfig().swiperPreItemSpace);
    return editModePageScale;
  }

  /**
   * Swiper的缩放值
   * @param screenWidth 屏幕宽度
   * @returns Swiper的缩放值
   */
  public static calSwiperScale(screenWidth: number): number {
    let pageWidth =
      (screenWidth - EditModeUtils.getPrevNextMargin()) * editModeManager.getEditModeStyleConfig().swiperEditScaleRate;
    let swiperScale =
      (pageWidth + editModeManager.getEditModeStyleConfig().swiperPreItemSpace) /
        (screenWidth - EditModeUtils.getPrevNextMargin());
    return swiperScale;
  }

  /**
   * 获取文件夹展开态背板宽度
   * @returns
   */
  public static getFolderBackgroundWidth(): number | string {
    let margin: number = EditModeUtils.getPrevNextMargin();
    if (margin === editModeManager.getEditModeStyleConfig().swiperPrevNextMargin) {
      return '100%';
    }
    let workSpaceWidth = AppStorage.get<number>('workSpaceWidth') as number;
    let pageWidth: number = workSpaceWidth - margin * 2;
    log.showInfo('getBackgroundWidth pageWidth: %{public}d', pageWidth);
    return pageWidth;
  }

  /**
   * 获取文件夹展开态背板Y轴偏移
   * @param dockHeight dock高度
   * @param bottomOfIndicator 导航条顶部距离dock高度
   * @param dockMargin dock跟Swiper的margin
   * @returns
   */
  public static getFolderBackgroundTranslateY(dockHeight: number, bottomOfIndicator: number,
    dockMargin: number): number {
    let screenHeight = AppStorage.get<number>('screenHeight') as number;
    let screenWidth = AppStorage.get<number>('screenWidth') as number;
    let workSpaceHeight = AppStorage.get<number>('workSpaceHeight') as number;
    const smartDockHeight: number = dockHeight * (screenHeight - dockMargin) / screenHeight;
    let marginBottom = smartDockHeight + bottomOfIndicator +
    EditModeConstants.SWIPER_EDIT_BOTTOM_INDICATOR + dockMargin;
    let backgroundHeight: number = EditModeUtils.getBackgroundHeight(screenHeight, screenWidth, workSpaceHeight);
    let bottom: number = (screenHeight - backgroundHeight * EditModeUtils.calEditModeScale(screenWidth)) / 2;
    log.showInfo('getBackgroundTranslateY marginBottom: %{public}d, bottom: %{public}d, dockHeight: %{public}d,' +
      'bottomOfIndicator: %{public}d, backgroundHeight: %{public}d',
      marginBottom, bottom, smartDockHeight, bottomOfIndicator, backgroundHeight);
    return bottom - marginBottom;
  }

  /**
   * 常态下文件夹内图标据文件夹左上角坐标转换为编辑模式下元素距离文件夹中心点坐标
   * 若非编辑模式，则正常返回常态下文件夹内图标元素距离文件夹中心点坐标
   * @param point 常态下文件夹内图标据文件夹左上角坐标
   * @param folder 目标文件夹
   * returns 编辑模式下元素距离文件夹中心点坐标
   */
  public static convertFolderCenterCoordinateToEditMode(
    point: RectangularCoordinates.Point,
    folder: GridLayoutItemInfo
  ): RectangularCoordinates.Point {
    let folderCenter = folderLayoutUtil.getFolderComponentCenterPosition(folder);
    let folderLeftTop = folderLayoutUtil.getFolderComponentLeftTopPosition(folder);
    let centerPos: RectangularCoordinates.Point = {
      x: folderCenter[0] - folderLeftTop.x,
      y: folderCenter[1] - folderLeftTop.y,
    };
    let posToCenter: RectangularCoordinates.Point = {
      x: point.x - centerPos.x,
      y: point.y - centerPos.y,
    };
    return {
      x: EditModeUtils.getDesktopScale() * posToCenter.x,
      y: EditModeUtils.getDesktopScale() * posToCenter.y
    };
  }

  /**
   * 将正常展开态文件夹位置转换到编辑模式位置
   * @param point
   * @returns
   */
  public static convertOpenFolderCoordinateToEditMode(
    point: RectangularCoordinates.Point
  ): RectangularCoordinates.Point {
    const screenWidth = AppStorage.get<number>('screenWidth') as number;
    const screenHeight: number = AppStorage.get<number>('screenHeight') as number;
    const centerX = screenWidth / 2;
    const centerY = screenHeight / 2;
    const offsetX = point.x - centerX;
    const offsetY = point.y - centerY;
    return {
      x: centerX + EditModeUtils.getDesktopScale() * offsetX,
      y: centerY + EditModeUtils.getDesktopScale() * offsetY +
        (editModeManager.isInEditMode() ? OpenFolderStyleConfig.getInstance().getCompensateTranslateYInEditMode() : 0)
    };
  }

  /**
   * 返回触发拖拽发起前的不同阶段
   * @param preDragStatus
   * @returns
   */
  public static handlePreDrag(preDragStatus: PreDragStatus): boolean | undefined {
    log.showInfo(`preDragChange ${preDragStatus}`);
    if (editModeManager.isInNormalMode()) {
      log.showInfo('ignore preDrag change in normalMode');
      return undefined;
    }
    // 拖拽浮起动效发起阶段
    if (preDragStatus === PreDragStatus.PREVIEW_LIFT_STARTED) {
      log.showInfo('preDragStatus preview lift start');
      return true;
    }
    // 拖拽落回动效结束阶段
    if (preDragStatus === PreDragStatus.PREVIEW_LANDING_FINISHED) {
      log.showInfo('preDragStatus preview landing finish');
      return false;
    }
    return undefined;
  }

  /**
   * 是否是小内折产品
   *
   * @returns true是，false不是
   */
  public static isSmallFoldProduct(): boolean {
    const FoldDeviceTypeValue = DeviceHelper.getFoldProductType();
    return FoldPhoneTypeValue.SMALL_FOLD === FoldDeviceTypeValue ||
      FoldPhoneTypeValue.EXPANDING_NEX_FORMS === FoldDeviceTypeValue;
  }

  /**
   * 是否为大大屏幕机产品展开态OR半展开态
   *
   * @returns true是，false不是
   */
  public static isBigFoldExpandedOrHalf(): boolean {
    return !EditModeUtils.isSmallFoldProduct() && DeviceHelper.isFoldExpandedOrHalf();
  }

  /**
   * 是否是直板机样式（直板机，大折闭合态，小折展开态）
   *
   * @returns boolean
   */
  public static isNormalPhoneType(): boolean {
    if (!EditModeUtils.isPhone) {
      return false;
    }
    if (EditModeUtils.isBigFoldExpandedOrHalf()) {
      return false;
    }
    return true;
  }

  /**
   * 折叠屏展开态获取相邻页
   *
   * @param page: 当前页的index
   * @returns 折叠屏展开态相邻页
   */
  public static getNeighborPage(page: number): number {
    if (page % StyleConstants.DEFAULT_2 === 0) {
      return page + StyleConstants.DEFAULT_1;
    } else {
      return page - StyleConstants.DEFAULT_1;
    }
  }

  /**
   * 获取与本页一起显示的页码
   *
   * @param page: 当前页的index
   * @param currentDisplayCount: 当前一屏显示几页
   * @returns 折叠屏展开态相邻页
   */
  public static getCurrentShowingPage(page: number, currentDisplayCount: number): number[] {
    const currentShowingPage: number[] = [];
    if (page < 0) {
      return currentShowingPage;
    }
    for (let i = 0; i < currentDisplayCount; i++) {
      currentShowingPage.push(Math.floor(page / currentDisplayCount) * currentDisplayCount + i);
    }
    return currentShowingPage;
  }

  /**
   * 获取编辑模式壁纸背景颜色
   *
   * @param isDarkMode: 当前是否为深色模式
   * @returns 编辑模式壁纸背景颜色
   */
  public static getEditModeWallpaperColor(isDarkMode: boolean): string {
    // 编辑模式下，浅色模式设置为10%的黑，深色模式设置为20%的白
    return isDarkMode ? `#33FFFFFF` : `#1A000000`;
  }

  public static sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}