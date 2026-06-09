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

import {
  AreaSpan,
  CardItemInfo,
  CommonConstants,
  DesktopParam,
  FormCommonUtil,
  FormLocation,
  GridLayoutItemInfo,
  GridLayoutUtil,
  launcherAbilityManager,
  StyleConstants
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { HashMap } from '@kit.ArkTS';
import { Log } from './Log';
import { PreviewUtils } from './PreviewUtils';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { bundleManagerFwk, IconResourceManager, TextColor } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { formHost, formInfo } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { StackData } from './data/StackData';
import { FormStackItemInfo } from '@ohos/formstack/src/main/ets/common/FormStackItemInfo';
import { DesktopPreviewRdbManager } from './DesktopPreviewRdbManager';
import { fileUri } from '@kit.CoreFileKit';
import { FolderItemData } from './data/FolderItemData';
import { FormItemData } from './data/FormItemData';
import { PreviewConstants } from './PreviewConstants';
import { NavigationUtil, WantParams } from '@ohos/desktopedit';
import { common } from '@kit.AbilityKit';
import { resourceManager } from '@kit.LocalizationKit';
import { image } from '@kit.ImageKit';
// import { hdsDrawable } from '@kit.UIDesignKit';
import { LayeredDrawableDescriptor } from '@ohos.arkui.drawableDescriptor';

const TAG = 'DesktopPreviewViewModel';
const HALF: number = 0.5;
const GRID_TEMPLATE = '1fr ';
const BORDER_G2 = 3.5;
const DESKTOP_MAX_FONT_SCALE = 1.15;

/**
 * SwiperPreview页面的ViewModel
 */
export class DesktopPreviewViewModel {
  private mFormWidthMaps: Map<string, number> = new Map<string, number>();

  private mFormHeightMaps: Map<string, number> = new Map<string, number>();

  private clockCardIds: Set<string> = new Set();

  /**
   * Form圆角
   */
  private mFormBorderRadius: Map<string, number> = new Map<string, number>();

  private mDesktopParam: DesktopParam = new DesktopParam();

  constructor() {
    this.mDesktopParam = AppStorage.get<DesktopParam>('desktopParam') as DesktopParam;
    if (this.mDesktopParam) {
      this.initFormDimensionParam(this.mDesktopParam.iconSize, this.mDesktopParam.spaceOfColumn,
        this.mDesktopParam.spaceOfRow, this.mDesktopParam.formItemSizeOffset);
    }
    Log.showInfo(TAG, 'new DesktopPreviewViewModel');
  }

  static getInstance(): DesktopPreviewViewModel {
    if (globalThis.desktopPreviewViewModel == null) {
      globalThis.desktopPreviewViewModel = new DesktopPreviewViewModel();
    }
    return globalThis.desktopPreviewViewModel;
  }

  public isFormStackValid(item: GridLayoutItemInfo): boolean {
    if (!item || !item.layoutInfo) {
      return false;
    }
    if (item.layoutInfo.length as number > 0) {
      if (item.layoutInfo[0].length as number > 0) {
        return true;
      }
    }
    return false;
  }

  public getDesktopParam(): DesktopParam {
    return this.mDesktopParam;
  }

  public addClockCardId(cardId: string): void {
    if (cardId !== '0') {
      this.clockCardIds.add(cardId);
    }
  }

  public getScaleSize(font: number): string {
    let scale = Math.min(DESKTOP_MAX_FONT_SCALE, this.mDesktopParam.fontSizeScale);
    return font * scale + 'vp';
  }

  private refreshMaskImage(): image.PixelMap {
    Log.showInfo(TAG, `refreshMaskImage start`);
    let maskImage: image.PixelMap | undefined = undefined;
    try {
      let resManager: resourceManager.ResourceManager = getContext()?.resourceManager;
      let layeredDrawableDescriptor =
        (resManager?.getDrawableDescriptor($r('app.media.drawable').id)) as LayeredDrawableDescriptor;
      maskImage = layeredDrawableDescriptor?.getMask().getPixelMap();
      Log.showInfo(TAG, `refreshMaskImage end`);
    } catch (err) {
      Log.showError(TAG, `refreshMaskImage error: ${err}`);
    }
    return maskImage as image.PixelMap;
  }

  public async initIconImage(itemInfo: GridLayoutItemInfo): Promise<string | image.PixelMap> {
    Log.showInfo(TAG, `init icon image ${itemInfo.bundleName}, itemInfo.iconResource: ${itemInfo.iconResource}`);
    if (itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      let iconImage: image.PixelMap | string = await DesktopPreviewViewModel.getInstance()
        .getMediaContent(itemInfo.appIconId, itemInfo.bundleName, itemInfo.moduleName as string);
      if (!iconImage && itemInfo.iconResource) {
        Log.showInfo(TAG, `${itemInfo.bundleName} shortcut get icon by iconResource directly`);
        return itemInfo.iconResource as string;
      }
      return iconImage ? iconImage : StyleConstants.DEFAULT_ICON;
    }
    if (!GridLayoutUtil.isAppInstalled(itemInfo) && itemInfo.iconResource) {
      Log.showInfo(TAG, `${itemInfo.bundleName} get pic by iconResource`);
      return itemInfo.iconResource as string;
    }
    if (!itemInfo.iconResource) {
      Log.showInfo(TAG, `${itemInfo.bundleName} iconResource is null!`);
    }
    Log.showInfo(TAG, `${itemInfo.bundleName} get pic by cache`);
    return await IconResourceManager.getInstance().getCombIcon(
      itemInfo.bundleName, itemInfo.moduleName, itemInfo.abilityName, undefined, 'CombIcon_DesktopPreviewView');
  }

  private getMediaContent(iconId: number, bundleName: string, moduleName: string): Promise<image.PixelMap | string> {
    let returnValue: image.PixelMap | string = '';
    try {
      let resMgr: resourceManager.ResourceManager =
        (getContext() as common.UIAbilityContext).createModuleResourceManager(bundleName, moduleName);
      let imageDescriptor: DrawableDescriptor = (resMgr.getDrawableDescriptor(Number(iconId), undefined, 0));
      returnValue = imageDescriptor.getPixelMap();
      Log.showInfo(TAG, `getMediaContentBase bundleName:${bundleName}, moduleName:${moduleName}, iconId:${iconId}`);
      let iconSizeOfGrid = bundleManagerFwk.getIconSizeOfGrid();
      let maskImage = this.refreshMaskImage();
      // returnValue = hdsDrawable.getHdsIcon(bundleName + '_shortcut', returnValue, iconSizeOfGrid, maskImage);
      if (!returnValue) {
        returnValue = resMgr.getMediaContentBase64Sync(iconId);
        Log.showInfo(TAG, 'getAppIconWithCache getMediaContentBase64 callback');
      }
      // MemoryUtils.removeNapiWrap(resMgr, false);
    } catch (error) {
      Log.showError(TAG, `getAppIconWithCache try error code: ${error.code}, message: ${error.message}`);
    }
    return new Promise((resolve, reject) => {
      resolve(returnValue);
    });
  }

  public getShortcutBackgroundImage(bundleName: string): string | image.PixelMap {
    let backgroundImage: string | image.PixelMap = '';
    let pixelMap: image.PixelMap | undefined = undefined;
    try {
      Log.showInfo(TAG, `getShortcutBackgroundImage bundleName: ${bundleName}`);
      let resManager: resourceManager.ResourceManager = getContext()?.resourceManager;
      let drawableDescriptor: DrawableDescriptor =
        (resManager.getDrawableDescriptor($r('app.media.shortcut_background').id)) as DrawableDescriptor;
      pixelMap = drawableDescriptor.getPixelMap();
      let iconSizeOfGrid = bundleManagerFwk.getIconSizeOfGrid();
      let maskImage = this.refreshMaskImage();
      // backgroundImage = hdsDrawable.getHdsIcon(bundleName + '_shortcut', pixelMap, iconSizeOfGrid, maskImage);
    } catch (err) {
      Log.showError(TAG, `getShortcutBackgroundImage error, code: ${err.code}, message: ${err.message}`);
    } finally {
      if (pixelMap) {
        pixelMap.release();
      }
    }
    return backgroundImage;
  }

  public dealWantParams(pageInfos: NavPathStack): void {
    const want: WantParams[] = pageInfos.getParamByName(PreviewConstants.PREVIEW_PATH) as WantParams[];
    let wantParams: WantParams = new WantParams();
    if (want.length > 0) {
      wantParams = want[0];
      if (wantParams.session) {
        NavigationUtil.session = wantParams.session;
        NavigationUtil.session.setReceiveDataCallback((data: Record<string, Object>) => this.dataReceiveCallback(data));
      }
    }
  }

  private dataReceiveCallback(data: Record<string, Object>): void {
    let keys: string[] = Object.keys(data);
    Log.showInfo(TAG, 'dataReceiveCallback keys:[%{public}s]', keys.join());
    keys.forEach(key => {
      if (key === 'clockStyle') {
        this.mDesktopParam.clockStyle = data[key] as string;
        this.clockCardIds.forEach((cardId: string) => {
          this.updateClockStyleById(cardId);
        });
      } else {
        Log.showWarn(TAG, 'dataReceiveCallback do nothing');
      }
    });
  };

  private updateClockStyleById(cardId: string): void {
    let wantParams: Record<string, Object> = {
      'ONE_MIRROR_CHANGE': 'true',
      'source': 'preview',
      'STYLE_PARAMETERS': this.mDesktopParam.clockStyle
    };
    Log.showInfo(TAG, `start update Clock, id ${cardId}, clockStyle: ${this.mDesktopParam.clockStyle}`);
    FormCommonUtil.requestFormWithParams(cardId, wantParams);
  }

  public initFolderData(folderItemData: FolderItemData, folderItem: GridLayoutItemInfo): void {
    let path: string = '';
    if (GridLayoutUtil.isSmallFolder(folderItem)) {
      folderItemData.isSmallFolder = true;
      path = `${this.mDesktopParam.cacheDir}/${folderItem.folderId}.png`;
    } else {
      folderItemData.isSmallFolder = false;
      path = `${this.mDesktopParam.filesDir}/${PreviewConstants.PREVIEW_FILE_PATH}/big_${folderItem.folderId}.png`;
    }
    folderItemData.imageUri = fileUri.getUriFromPath(path);
    folderItemData.mFolderName =
      DesktopPreviewRdbManager.getInstance().getRealFolderName(folderItem.folderName ?? '');
    if (!folderItemData.isSmallFolder && folderItem.area) {
      folderItemData.imageWidth = this.getWidthByArea(folderItem.area[0]);
      folderItemData.imageHeight = this.getHeightByArea(folderItem.area[1]);
    } else {
      let size = this.getHeightByArea(1);
      folderItemData.imageWidth = size;
      folderItemData.imageHeight = size;
    }
    Log.showInfo(TAG, `imageWidth: ${folderItemData.imageWidth}, imageHeight: ${folderItemData.imageHeight}`);
  }

  public initStackData(stackData: StackData, mFormStackItem: FormStackItemInfo): void {
    let items: CardItemInfo[] = mFormStackItem.layoutInfo[0];
    let area: number[];
    if (CheckEmptyUtils.isEmptyArr(mFormStackItem.area)) {
      area = items[0].area as number[];
    } else {
      area = mFormStackItem.area;
    }
    let cardDimension = CardItemInfo.getCardDimension(area);
    stackData.radius = this.getFormBorderRadius(cardDimension);
    stackData.size = mFormStackItem.layoutInfo[0]?.length;
    stackData.width = Number(this.mFormWidthMaps.get(cardDimension.toString()));
    stackData.height = Number(this.mFormHeightMaps.get(cardDimension.toString()));
    stackData.formRatio = stackData.width > StyleConstants.CARD_BACKGROUND_SIZE_OFFSET ?
      (stackData.width - StyleConstants.CARD_BACKGROUND_SIZE_OFFSET) / stackData.width : 0;

    if (!PreviewUtils.isEmpty(items)) {
      this.showTopName(stackData, items[items.length - 1] as Object as GridLayoutItemInfo);
    }
    Log.showInfo(TAG, `initStackData cardDimension: ${cardDimension}, stackData: ${JSON.stringify(stackData)}`);
  }

  public initFormData(formItem: GridLayoutItemInfo, formItemData: FormItemData, isShowName: boolean): void {
    if (isShowName && this.mDesktopParam.isShowName) {
      Log.showInfo(TAG, `initFormData[${formItem.cardId}] bundleName: ${formItem.bundleName}`);
      this.showTopName(formItemData, formItem);
    }
    let dimension: number = this.mDesktopParam.isSimpleMode ? CommonConstants.CARD_DIMENSION_2x4 :
      CardItemInfo.getCardDimension(formItem.area);
    formItem.cardId = '0';
    formItemData.radius = this.getFormBorderRadius(dimension);
    formItemData.width = Number(this.mFormWidthMaps.get(dimension.toString()));
    formItemData.height = Number(this.mFormHeightMaps.get(dimension.toString()));
    Log.showInfo(TAG, `card bundleName: ${formItem.bundleName} card appName: ${formItem.appName}
      card width: ${formItemData.width} card height: ${formItemData.height}`);
  }

  private async showTopName(stackData: StackData | FormItemData, item: GridLayoutItemInfo): Promise<void> {
    if (!item.appLabelId) {
      try {
        item.appLabelId = await launcherAbilityManager.getAppLabelId(item.bundleName);
      } catch (error) {
        Log.showError(TAG, `getAppLabelId error, bundleName: ${item.bundleName}, ${error.code}:${error.message}`);
      }
    }
    DesktopPreviewRdbManager.getInstance().getItemName(item, this.mDesktopParam, (name: string): void => {
      stackData.name = name;
    });
  }

  private initFormDimensionParam(iconSize: number, spaceOfColumn: number, spaceOfRow: number,
    formItemSizeOffset: number): void {
    // 1 x 1  width * height
    let widthDimension0: number = iconSize;
    let heightDimension0: number = iconSize;
    // 2 x 1  width * height
    let widthDimension1: number = iconSize * StyleConstants.DEFAULT_2 + spaceOfRow;
    let heightDimension1: number = iconSize;
    // 2 x 2
    let widthDimension2: number = widthDimension1;
    let heightDimension2: number = widthDimension1;
    // 4 x 2
    let widthDimension3: number = (iconSize + spaceOfColumn) * StyleConstants.DEFAULT_2 + widthDimension1;
    let heightDimension3: number = heightDimension2;
    // 4 x 4
    let widthDimension4: number = widthDimension3;
    let heightDimension4: number = (iconSize + spaceOfRow) * StyleConstants.DEFAULT_2 + widthDimension1;
    // 6 x 4
    let widthDimension5: number = widthDimension3;
    let heightDimension5: number = (iconSize + spaceOfRow) * StyleConstants.DEFAULT_4 + widthDimension1;

    this.mFormBorderRadius.set(CommonConstants.CARD_DIMENSION_1x2.toString(), this.calculateSmallFormRadius());
    this.mFormBorderRadius.set(CommonConstants.CARD_DIMENSION_2x2.toString(), this.mDesktopParam.bigFolderRadius);

    this.mFormWidthMaps.set(CommonConstants.CARD_DIMENSION_1x1.toString(), widthDimension0 + formItemSizeOffset);
    this.mFormHeightMaps.set(CommonConstants.CARD_DIMENSION_1x1.toString(), heightDimension0 + formItemSizeOffset);
    this.mFormWidthMaps.set(CommonConstants.CARD_DIMENSION_1x2.toString(), widthDimension1 + formItemSizeOffset);
    this.mFormHeightMaps.set(CommonConstants.CARD_DIMENSION_1x2.toString(), heightDimension1 + formItemSizeOffset);
    this.mFormWidthMaps.set(CommonConstants.CARD_DIMENSION_2x2.toString(), widthDimension2 + formItemSizeOffset);
    this.mFormHeightMaps.set(CommonConstants.CARD_DIMENSION_2x2.toString(), heightDimension2 + formItemSizeOffset);
    this.mFormWidthMaps.set(CommonConstants.CARD_DIMENSION_2x4.toString(), widthDimension3 + formItemSizeOffset);
    this.mFormHeightMaps.set(CommonConstants.CARD_DIMENSION_2x4.toString(), heightDimension3 + formItemSizeOffset);
    this.mFormWidthMaps.set(CommonConstants.CARD_DIMENSION_4x4.toString(), widthDimension4 + formItemSizeOffset);
    this.mFormHeightMaps.set(CommonConstants.CARD_DIMENSION_4x4.toString(), heightDimension4 + formItemSizeOffset);
    this.mFormWidthMaps.set(CommonConstants.CARD_DIMENSION_6x4.toString(), widthDimension5 + formItemSizeOffset);
    this.mFormHeightMaps.set(CommonConstants.CARD_DIMENSION_6x4.toString(), heightDimension5 + formItemSizeOffset);
  }

  public getFormBorderRadius(cardDimension: number): number {
    let radius: number = CommonConstants.INVALID_VALUE;
    if (PreviewUtils.isEmpty(cardDimension) || (cardDimension as number) === CommonConstants.CARD_DIMENSION_1x1) {
      return radius;
    }

    // small form: 1*2 and 2*1
    if (cardDimension === CommonConstants.CARD_DIMENSION_1x2) {
      radius = this.mFormBorderRadius.get(CommonConstants.CARD_DIMENSION_1x2.toString()) as number;
    } else {
      // big form: 2*2 and bigger
      radius = this.mFormBorderRadius.get(CommonConstants.CARD_DIMENSION_2x2.toString()) as number;
    }

    if (PreviewUtils.isEmpty(radius)) {
      radius = CommonConstants.INVALID_VALUE;
    }
    radius = this.updateFormBorderRadiusToG2(radius, cardDimension);
    return radius;
  }

  private updateFormBorderRadiusToG2(radius: number, dimension?: number): number {
    if (PreviewUtils.isEmpty(dimension) || (dimension as number) === CommonConstants.CARD_DIMENSION_1x1) {
      return radius;
    }
    try {
      // 如果主题包中设置了radius，则使用主题包资源，此时不需要做G2圆角规避
      let themeRadius = -1;
      themeRadius = ResUtils.getConvertNumber($r('app.float.icon_radius'));
      if (themeRadius >= 0) {
        Log.showInfo(TAG, `get theme radius: ${themeRadius}`);
        return radius;
      }
    } catch (e) {
      Log.showError(TAG, `getConvertNumber error: ${e?.message}`);
    }
    let desktopPreviewViewModel: DesktopPreviewViewModel = DesktopPreviewViewModel.getInstance();
    // 底座要求G2圆角的边长半径比要大于3.5，不满足时画不了G2圆角会有截断，当前根据ux诉求短期内在不满足G2时调小圆角大小规避截断
    let formItemWidth: number = this.mFormWidthMaps.get(String(dimension)) as number;
    let formItemHeight: number = this.mFormHeightMaps.get(String(dimension)) as number;
    let minHeight: number = Math.min(formItemWidth, formItemHeight);
    return minHeight / BORDER_G2 > radius ? radius : minHeight / BORDER_G2;
  }

  public calculateSmallFormRadius(): number {
    let radius: number = (this.mDesktopParam.bigFolderRadius + this.mDesktopParam.smallFolderRadius) / 2;
    return radius;
  }

  /**
   * 构建want参数
   * 因为onAcquired方法触发时，卡片有可能未创建完成，导致样式显示错误。
   * @param mFormItem 卡片
   * @returns 组件参数
   */
  public buildWantParam(mFormItem: GridLayoutItemInfo): Want {
    Log.showInfo(TAG, `buildWantParam cardId:${mFormItem.cardId} bundleName:${mFormItem.bundleName} cardName:${mFormItem.cardName} enter`);
    let want: Want = FormCommonUtil.getCommonWant({
      extend1: mFormItem?.extend1,
      isTransparent: mFormItem.isTransparent,
      formLocation: FormLocation.OTHER
    })
    if (!this.cardNeedTextColor(mFormItem)) {
      return want;
    }
    if (!want.parameters) {
      want.parameters = {};
    }
    let textColor: TextColor = new TextColor(this.mDesktopParam.nameFontColor, 0, 0, 0, '', 0);
    want.parameters[formInfo.FormParam.HOST_BG_INVERSE_COLOR_KEY] = textColor;
    want.parameters['ONE_MIRROR_CHANGE'] = 'true';
    want.parameters['source'] = 'preview';
    want.parameters['STYLE_PARAMETERS'] = this.mDesktopParam.clockStyle;
    return want;
  }

  /**
   * 判断卡片是否需要改变字体样式
   * @param mFormItem 卡片
   * @returns true:需要 false:不需要
   */
  private cardNeedTextColor(mFormItem: GridLayoutItemInfo): boolean {
    let isWeatherCard = mFormItem.cardName === PreviewConstants.CLOCK_WEATHER_CARD_NAME &&
      mFormItem.bundleName === PreviewConstants.CLOCK_WEATHER_BUNDLE_NAME;
    if (!isWeatherCard) {
      Log.showInfo(TAG, `cardNeedTextColor cardId:${mFormItem.cardId}} is not weather card`);
      return false;
    }
    return true;
  }

  public getColumnTemplate(): string {
    if (PreviewUtils.isEmpty(this.mDesktopParam)) {
      return GRID_TEMPLATE;
    }
    let res: string = '';
    for (let i = 0; i < this.mDesktopParam.columns; i++) {
      res += GRID_TEMPLATE;
    }
    return res;
  }

  public getRowTemplate(): string {
    if (PreviewUtils.isEmpty(this.mDesktopParam)) {
      return GRID_TEMPLATE;
    }
    let res: string = '';
    for (let i = 0; i < this.mDesktopParam.rows; i++) {
      res += GRID_TEMPLATE;
    }
    return res;
  }

  /**
   * 根据Area获取宽度
   *
   * @param area 依据的Area
   * @returns 最终的宽度
   */
  public getWidthByArea(span: number): number {
    if (span === AreaSpan.SPAN_1.valueOf()) {
      return this.getSizeX1();
    } else if (span === AreaSpan.SPAN_2.valueOf()) {
      return this.getSizeX2();
    } else {
      return this.getSizeX4();
    }
  }

  /**
   * 根据Area获取高度
   *
   * @param area 依据的Area
   * @returns 最终的高度
   */
  public getHeightByArea(span: number): number {
    if (span === AreaSpan.SPAN_1.valueOf()) {
      return this.getHeightX1();
    } else if (span === AreaSpan.SPAN_2.valueOf()) {
      return this.getSizeX2();
    } else if (span === AreaSpan.SPAN_4.valueOf()) {
      return this.getHeightX4();
    } else {
      return this.getHeightX6();
    }
  }

  /**
   * 获取 x1 大小
   * @returns 跨度1大小
   */
  private getSizeX1(): number {
    return this.mDesktopParam.iconSize;
  }

  /**
   * 获取 x1 大小
   * @returns 跨度1高度大小
   */
  private getHeightX1(): number {
    return Number(this.mFormHeightMaps.get(CommonConstants.CARD_DIMENSION_1x2.toString())) ?? 0;
  }

  /**
   * 获取 x2 大小
   * @returns 跨度2大小
   */
  private getSizeX2(): number {
    return Number(this.mFormHeightMaps.get(CommonConstants.CARD_DIMENSION_2x2.toString())) ?? 0;
  }

  /**
   * 获取 x4 大小
   * @returns 跨度4大小
   */
  private getSizeX4(): number {
    return Number(this.mFormWidthMaps.get(CommonConstants.CARD_DIMENSION_2x4.toString())) ?? 0;
  }

  /**
   * 获取 x4 大小
   * @returns 跨度4高度大小
   */
  private getHeightX4(): number {
    return Number(this.mFormHeightMaps.get(CommonConstants.CARD_DIMENSION_4x4.toString())) ?? 0;
  }

  /**
   * 获取 x6 大小
   * @returns 跨度6高度大小
   */
  private getHeightX6(): number {
    return Number(this.mFormHeightMaps.get(CommonConstants.CARD_DIMENSION_6x4.toString())) ?? 0;
  }
}