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

import { bundleManager } from '@kit.AbilityKit';
import formInfo from '@ohos.app.form.formInfo';
import image from '@ohos.multimedia.image';
import util from '@ohos.util';
import { componentUtils, Offset, Size } from '@kit.ArkUI';
import { formHost } from '@kit.FormKit';
import { BusinessError } from '@kit.BasicServicesKit';
import type Want from '@ohos.app.ability.Want';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  PixelMapUtil,
  CommonUtils,
} from '@ohos/basicutils';
import { launcherStatusUtil } from '@ohos/windowscene';
import {
  DeviceHelper,
  TextColor,
  WallpaperColorManager,
  HiDfxEventUtil,
  FormLocationType,
  ReportCardFaultInformationEvent,
  ErrorCardResultType,
} from '@ohos/frameworkwrapper';
import { ScenePanelState } from '@ohos/windowscene';
import { OverflowConstants, FormType } from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';
import { CardItemInfo } from '../bean/CardItemInfo';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { CommonConstants, FormLocation } from '../constants/CommonConstants';
import { OneShotUpdateClockCardStyle } from '../viewmodel/OneShotUpdateClockCardStyle';
import { GameCardInfo } from '../bean/GameCardInfo';
import {
  FormLayoutCacheManager,
  FormModel,
  RdbStoreManager,
} from '../TsIndex';
import { Extend1Data } from '../bean/Extend1Data';

const TAG = 'FormCommonUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const FORM_TRANSPARENCY_COLOR = '#00000000';
const INVALID_FORM_COMPONENT_ID: string = 'FormItem_InvalidId';
const compareInterval: number = 60 * 60 * 1000; // 一个小时对比一次数据
const compareDelay: number = 5 * 1000; // 延迟5s执行对比任务
const CARD_ID_SEPARATOR: string = '-';
const DESKTOP_CONTAINER: number = -100;

/**
 * Defines the Form common want parameter.
 *
 * @interface FormWantParamInterface
 */
export interface FormWantParamInterface {
  extend1?: string;
  isTransparent?: boolean;
  formLocation?: Number;
  disableGesture?: boolean;
  cardName?: string;
  bundleName?: string;
  skeletonEnable?: boolean;
  disableBlurBackground?: boolean;
  isOuterDesktop?: boolean;
  liveFormWidth?: number;
  liveFormHeight?: number;
  targetFormData?: string;
}

export interface FormZoomSupportInfo {
  cardName: string;
  cardDimension: number;
}

export class FormCommonUtil {
  /**
   * Get FormComponent common want parameters.
   *
   * @param formWantParamInterface form want parameters interface
   * @returns want
   */
  public static getCommonWant(formWantParamInterface: FormWantParamInterface): Want {
    let want: Want = {};
    if (!formWantParamInterface) {
      return want;
    }
    if (formWantParamInterface.extend1) {
      try {
        want = JSON.parse(formWantParamInterface.extend1);
        if (CheckEmptyUtils.isEmpty(want) || typeof(want) !== 'object') {
          // json字串异常解出空值,重新给want赋默认值
          log.showError('error extend1 info: %{public}s want: %{public}s type: %{public}s',
            formWantParamInterface.extend1, JSON.stringify(want), typeof(want));
          want = {};
        }
      } catch (error) {
        log.error('json parse object error.');
        want = {};
      }
    }

    if (!want.parameters) {
      want.parameters = {};
    }
    if (formWantParamInterface.liveFormWidth && formWantParamInterface.liveFormHeight) {
      want.parameters[formInfo.FormParam.FORM_WIDTH_VP_KEY] = formWantParamInterface.liveFormWidth;
      want.parameters[formInfo.FormParam.FORM_HEIGHT_VP_KEY] = formWantParamInterface.liveFormHeight;
    }

    if (formWantParamInterface.formLocation !== undefined) {
      want.parameters[CommonConstants.FORM_LOCATION_KEY] = formWantParamInterface.formLocation;
    }

    if (formWantParamInterface.skeletonEnable !== undefined) {
      log.showInfo(`FORM_ENABLE_SKELETON_KEY:${formWantParamInterface.skeletonEnable}`);
      want.parameters[CommonConstants.FORM_ENABLE_SKELETON_KEY] = formWantParamInterface.skeletonEnable;
    }

    if (!CheckEmptyUtils.isEmpty(formWantParamInterface.targetFormData)) {
      log.showInfo(`TARGET_FORM_DATA: ${formWantParamInterface.targetFormData}`);
      want.parameters[CommonConstants.FORM_TARGET_FORM_DATA] = formWantParamInterface.targetFormData ?? '';
    }

    // 堆叠创建卡片时设置disableGesture=true表示不响应卡片内部列表滑动
    if (formWantParamInterface.disableGesture !== undefined) {
      log.showInfo(`disableGesture is: ${formWantParamInterface.disableGesture}`);
      want.parameters[CommonConstants.FORM_DISABLE_GESTURE_KEY] = formWantParamInterface.disableGesture;
    }

    if (formWantParamInterface.cardName !== undefined && formWantParamInterface.bundleName !== undefined) {
      // 发送天气时钟卡片字体样式
      let clockStyle = OneShotUpdateClockCardStyle.getInstance()
        .getClockStyle(formWantParamInterface.cardName, formWantParamInterface.bundleName);
      log.showInfo(`clockStyle is: ${clockStyle}`);
      want.parameters[CommonConstants.FORM_CLOCK_STYLE_FLAG_KEY] = 'true';
      want.parameters[CommonConstants.FORM_CLOCK_STYLE_KEY] = clockStyle ?? '';
    }

    // 卡片管理中的卡片不使能模糊背板, 使用默认背板
    want.parameters[CommonConstants.FORM_DISABLE_BLUR_BACKGROUND] =
      Boolean(formWantParamInterface.disableBlurBackground);

    if (!formWantParamInterface.isTransparent) {
      return want;
    }

    want.parameters[CommonConstants.FORM_BACKGROUND_TRANSPARENCY] = FORM_TRANSPARENCY_COLOR;
    let formColor: TextColor = formWantParamInterface?.isOuterDesktop ? WallpaperColorManager.getInstance()?.mOuterTextColor :
      WallpaperColorManager.getInstance()?.mTextColor;
    if (!CheckEmptyUtils.checkStrIsEmpty(formColor?.mTextColor) &&
      formWantParamInterface.formLocation === FormLocation.DESKTOP) {
      log.showInfo(`formColor is: ${formColor.mTextColor}, isOuterDesktop: ${formWantParamInterface?.isOuterDesktop}`);
      want.parameters[formInfo.FormParam.HOST_BG_INVERSE_COLOR_KEY] = formColor;
    } else {
      log.showError('formColor error!');
    }

    return want;
  }

  public static getFormComponentId(card: CardItemInfo | GridLayoutItemInfo,
    isWithName: boolean = false, TAG?: string): string {
    if (CheckEmptyUtils.checkStrIsEmpty(card?.bundleName) || CheckEmptyUtils.checkStrIsEmpty(card.cardId)) {
      log.showError('bundleName or cardId is invalid!');
      return INVALID_FORM_COMPONENT_ID;
    }

    const componnetId: string = `FormItem_${card.bundleName}_${card.cardId}`;
    return isWithName ? `${componnetId}_WithName` : componnetId;
  }

  public static getFormStackComponentId(formStackId: string): string {
    if (CheckEmptyUtils.checkStrIsEmpty(formStackId)) {
      log.showInfo('formStackId is empty!');
      return '';
    }

    return `FormStackView_${formStackId}_column`;
  }

  public static updateFormColor(formId: string, isOuterDesktop: boolean): void {
    let textColor: TextColor = isOuterDesktop ?
    WallpaperColorManager.getInstance().mOuterTextColor : WallpaperColorManager.getInstance()?.mTextColor;
    if (CheckEmptyUtils.checkStrIsEmpty(textColor?.mTextColor)) {
      log.showError('textColor params error');
      return;
    }

    try {
      let params: Record<string, Object> = {};
      params[formInfo.FormParam.HOST_BG_INVERSE_COLOR_KEY] = textColor;
      formHost.requestFormWithParams(formId, params).then(() => {
        log.showInfo(`formHost requestFormWithParams ${formId} success, color is ${textColor.mTextColor}`);
      }).catch((error: BusinessError) => {
        log.showError(`formHost requestFormWithParams error, code: ${error.code}, message: ${error.message}`);
      });
    } catch (error) {
      log.showError(`catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message}`);
    }
  }

  public static requestFormWithParams(formId: string, wantParams?: Record<string, Object>): void {
    log.showInfo(`formHost requestFormWithParams  ${formId}`);
    try {
      formHost.requestFormWithParams(formId, wantParams).then(() => {
        log.showInfo(`formHost requestFormWithParams ${formId} success`);
      }).catch((error: BusinessError) => {
        log.showError(`formHost requestFormWithParams error, code: ${error.code}, message: ${error.message}`);
      });
    } catch (error) {
      log.showError(`catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message}`);
    }
  }

  public static transformCardId(cardId: string): string {
    if (FormCommonUtil.isCardIdInvalid(cardId)) {
      return '0';
    }
    return cardId;
  }

  public static isCardIdInvalid(cardId: string): boolean {
    return CheckEmptyUtils.checkStrIsEmpty(cardId) || String(cardId) === '0' ||
    String(cardId).startsWith(CommonConstants.CARD_DEFAULT_ID_PREFIX);
  }

  /**
   * PixelMap转String
   * @param pixelMap
   * @returns pixelMap转换后的字符串
   */
  public static async convertPixelMap2String(pixelMap: image.PixelMap): Promise<string> {
    let imagePackerApi: image.ImagePacker | undefined = undefined;
    try {
      // 创建ImagePacker实例
      imagePackerApi = image.createImagePacker();
      // 设置打包参数: (1)format：图片打包格式，只支持 jpg 和 webp (2)quality：JPEG 编码输出图片质量 (3)bufferSize：图片大小，默认 10M
      const packOpts: image.PackingOption = { format: 'image/png', quality: 100 };
      let base64 = new util.Base64Helper();
      let arr: ArrayBuffer = await imagePackerApi.packing(pixelMap, packOpts);
      return base64.encodeToString(new Uint8Array(arr)).catch((error: Error) => {
        log.showError(TAG, `convertPixelMap2String Uint8Array error, ${error?.message}.`);
        return '';
      });
    } catch (error) {
      log.showError(TAG, `encodeToString error, ${(error as BusinessError).code}, ${(error as BusinessError).message}`);
      return new Promise((r) => {
        r('');
      });
    } finally {
      imagePackerApi?.release();
    }
  }

  /**
   * String转PixelMap
   * @param pixelMap转换后的字符串
   * @returns pixelMap
   */
  public static async convertString2PixelMap(str: string): Promise<image.PixelMap | undefined> {
    let base64 = new util.Base64Helper();
    let arr: Uint8Array = new Uint8Array();
    let imageSource : image.ImageSource | undefined = undefined;
    try {
      arr = base64.decodeSync(str);
      let arrBuffer: ArrayBuffer = arr.buffer as Object as ArrayBuffer;
      imageSource = image.createImageSource(arrBuffer);
      const pixelMap = await imageSource.createPixelMap();
      PixelMapUtil.addName(pixelMap, `FormCommonUtil_convert`);
      return pixelMap;
    } catch (error) {
      let code: number = (error as BusinessError).code;
      let message: string = (error as BusinessError).message;
      log.showError(TAG, `convertString2PixelMap, arr get error, code: ${code}, message: ${message}`);
    } finally {
      imageSource?.release();
    }
    return undefined;
  }

  /**
   * 获取formInfo中的enableBlurBackground字段值
   * @param cardItem
   * @returns boolean
   */
  public static getEnableBlurBackground(cardItem: CardItemInfo | GridLayoutItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(cardItem)) {
      log.showWarn('empty cardItem');
      return false;
    }
    if (cardItem.isTransparent) {
      log.showInfo('transparent card');
      return false;
    }
    let formInfos: CardItemInfo[] | undefined = FormModel.getInstance().getAppItemFormInfo(cardItem.bundleName);
    if (!formInfos || CheckEmptyUtils.isEmptyArr(formInfos)) {
      log.showWarn('empty formsInfo');
      return false;
    }
    let formInfo: CardItemInfo | undefined = formInfos.find(item => {
      return cardItem.abilityName === item.abilityName && cardItem.cardName === item.cardName;
    });
    if (formInfo) {
      let enableBlurBackground = formInfo.enableBlurBgr;
      log.showInfo(`get enableBlurBackground: ${enableBlurBackground}`);
      return Boolean(enableBlurBackground);
    }
    return false;
  }

  public static getFormZoomSupportInfos(cardItem: CardItemInfo): FormZoomSupportInfo[] {
    if (CheckEmptyUtils.isEmpty(cardItem)) {
      log.showWarn('empty cardItem');
      return [];
    }
    let formInfos: CardItemInfo[] | undefined = FormModel.getInstance().getAppItemFormInfo(cardItem.bundleName);
    if (!formInfos || CheckEmptyUtils.isEmptyArr(formInfos)) {
      log.showWarn('empty formsInfo');
      return [];
    }
    let formInfo: CardItemInfo | undefined = formInfos.find(item => {
      return cardItem.abilityName === item.abilityName && cardItem.cardName === item.cardName;
    });
    if (formInfo?.resizable && formInfo?.supportDimensions.length > 1) {
      let supportDimensions: number[] = formInfo.supportDimensions;
      supportDimensions.sort((a, b) => a - b);
      return supportDimensions.map((item) => {
        return {
          cardName: cardItem.cardName,
          cardDimension: item
        } as FormZoomSupportInfo;
      });
    } else if (formInfo?.resizable && formInfo?.groupId) {
      let supportItems = formInfos.filter(item => {
        return item.abilityName === formInfo?.abilityName && item.groupId === formInfo?.groupId;
      })
      supportItems.sort((a, b) => a.cardDimension - b.cardDimension);
      return supportItems.map((item) => {
        return {
          cardName: item.cardName,
          cardDimension: item.cardDimension
        } as FormZoomSupportInfo;
      });
    }
    return [];
  }

  /**
   * 根据堆叠intent字段进行排序
   *
   * @param intent 排序参照JSON字符串
   * @param tempItem 排序数组
   * @returns void
   */
  public static sortFormStack(intent: string, tempItem: GridLayoutItemInfo[]): void {
    const intentInfo: Map<string, Object> = CommonUtils.jsonStrToMap(intent);
    const cardOrder: string[] = intentInfo.get('cardOrder') as string[];
    if (!Array.isArray(cardOrder) || cardOrder.length === 0) {
      return;
    }
    const sortMap: Map<string, number> = FormCommonUtil.createSortMap(cardOrder);
    // 排序
    tempItem.sort((a: GridLayoutItemInfo, b: GridLayoutItemInfo) =>
      (sortMap.get(a.cardId ?? '') ?? -1) - (sortMap.get(b.cardId ?? '') ?? -1));
  }

  /**
   * 创建排序索引Map-数组转Map
   *
   * @param cardOrder 排序参照数组
   * @returns Map
   */
  public static createSortMap(cardOrder: string[]): Map<string, number> {
    const sortMap = new Map<string, number>();
    for (let i = 0; i < cardOrder.length; i++) {
      sortMap.set(cardOrder[i], i);
    }
    return sortMap;
  }

  /*
   * 获取卡片的尺寸信息，包括卡片左上角相对于屏幕左上角的位置，以及卡片宽高属性
   * @param formComponentBuilderId 卡片所属的builderId
   * @returns 卡片尺寸信息
   */
  public static getFormRect(formComponentBuilderId: string): formInfo.Rect | undefined {
    try {
      let componentItem: componentUtils.ComponentInfo = componentUtils.getRectangleById(formComponentBuilderId);
      if (CheckEmptyUtils.isEmpty(componentItem)) {
        log.showInfo('getFormRect componentItem is empty');
        return undefined;
      }
      let windowOffset: Offset = componentItem.windowOffset;
      let size: Size = componentItem.size;
      if (CheckEmptyUtils.isEmpty(windowOffset) || CheckEmptyUtils.isEmpty(size)) {
        log.showInfo('getFormRect size is empty');
        return undefined;
      }
      let formRect: formInfo.Rect = {
        left: px2vp(windowOffset.x),
        top: px2vp(windowOffset.y),
        width: px2vp(size.width),
        height: px2vp(size.height)
      }
      return formRect;
    } catch (error) {
      log.showError(`getFormRect: Error processing request, code is ${error?.code},
        message is ${error?.message}, formId:${formComponentBuilderId}`);
    }
    return undefined;
  }

  /**
   * 获取卡片类型
   *
   * @param gameCardInfo 卡片信息
   * @returns 0表示普通卡片, 1表示场景动效卡片, 2表示趣味交互卡片
   */
  public static getFormType(gameCardInfo?: GameCardInfo): number {
    if (!gameCardInfo) {
      return FormType.COMMON_FORM_TYPE;
    } else if (gameCardInfo.extensionType === OverflowConstants.ANIMATION_TYPE) {
      return FormType.ANIMATION_FORM_TYPE;
    } else {
      return FormType.INTERACTION_FORM_TYPE;
    }
  }

  public static compareTimerId: number | null = null;

  /**
   * 对比缓存和数据库
   *
   */
  public static async innerCompareCacheAndRdb(): Promise<void> {
    if (AppStorage.get('onDeskTopState') !== ScenePanelState.HOME) {
      log.showWarn('innerCompareCacheAndRdb do not operate: deskTopState is not home');
      return;
    }

    const rdbCardSet: Set<CardItemInfo> = new Set(await RdbStoreManager.getInstance().getAllFormInfos());
    const cacheCardSet: Set<GridLayoutItemInfo> = new Set(FormLayoutCacheManager.getInstance().selectAllFormsList());
    const rdbSize: number = rdbCardSet.size;
    const cacheSize: number = cacheCardSet.size;
    for (let cacheItem of cacheCardSet.values()) {
      for (let rdbItem of rdbCardSet.values()) {
        if (cacheItem.cardId === rdbItem.cardId) {
          rdbCardSet.delete(rdbItem);
          cacheCardSet.delete(cacheItem);
          break;
        }
      }
    }
    let rdbData: CardItemInfo[] = Array.from(rdbCardSet);
    let cacheData: GridLayoutItemInfo[] = Array.from(cacheCardSet);
    log.showInfo('rdbSize = %{public}s; cacheSize = %{public}s; in rdbCard (not in cache): #%{public}s#; ' +
      'in cache (not in rdb): #%{public}s#;', String(rdbSize), String(cacheSize),
      rdbData.map(item => `${item.cardId}/${item.page}/${item.row}/${item.column}/${item.container}`).join(','),
      cacheData.map(item => `${item.cardId}/${item.page}/${item.row}/${item.column}/${item.container}`).join(','));
    if (cacheData.length > 0) {
      FormCommonUtil.fillCacheDataToRDB(cacheData);
    }

    // 重启定时任务
    if (FormCommonUtil.compareTimerId === null) {
      FormCommonUtil.compareTimerId = setInterval(() => {
        FormCommonUtil.innerCompareCacheAndRdb();
      }, compareInterval);
    }
  }

  public static compareCacheAndRdb(): void {
    if (FormCommonUtil.compareTimerId) {
      // 清除定时任务
      clearInterval(FormCommonUtil.compareTimerId);
      FormCommonUtil.compareTimerId = null;
    }
    FormCommonUtil.execCompareTask();
  }

  public static execCompareTask = CommonUtils.debounce(FormCommonUtil.innerCompareCacheAndRdb, compareDelay);

  /*
  * 生成随机cardId
  * @returns string
  */
  public static getCardUUID(): string {
    let id = CommonConstants.CARD_DEFAULT_ID_PREFIX + CARD_ID_SEPARATOR;
    id += util.generateRandomUUID();
    return id;
  }

  /*
  * 卡片合法性校验，注意，此方法用于卡片重排时清脏，对于合法的判断较为宽松，其他场景调用此方法需要评估
  * @param GridLayoutItemInfo
  * @returns boolean
  */
  public static isFormValid(item: GridLayoutItemInfo): boolean {
    if (!item || !item.bundleName) {
      return false;
    }

    // 2. 如果卡片对应应用没有安装，可认为卡片没安装
    if (!FormCommonUtil.isAppInstalled(item.bundleName)) {
      return false;
    }

    // 3. 其他情况默认安装
    return true;
  }

  public static reportCardOperateRDBError(cardItem: CardItemInfo | GridLayoutItemInfo, operateMsg: string): void {
    if (!cardItem) {
      log.showWarn(TAG, 'report remove card UE event failed, cardItem is undefined.');
      return;
    }
    const event: ReportCardFaultInformationEvent = {
      faultInformation:HiDfxEventUtil.CARD_OPERATE_RDB_ERROR,
      formId: `${cardItem.cardId}`,
      bundleName: cardItem.bundleName,
      moduleName: `${cardItem.moduleName}`,
      formName: `${cardItem.cardName}`,
      area: cardItem.area ?? [],
      position: FormCommonUtil.getReportPosition(cardItem),
      location: FormLocationType.DESKTOP,
      sourceType: Extend1Data.getCardSourceType(cardItem.extend1),
      formType: FormCommonUtil.getFormType(cardItem.gameCardInfo),
      resultType: ErrorCardResultType.OTHERS,
      operateMsg: operateMsg,
    };
    HiDfxEventUtil.reportCardFaultInformation(event);
  }

  public static reportDirtyFormStackDegradation(cardItem: GridLayoutItemInfo): void {
    if (!cardItem) {
      log.showWarn(TAG, 'report remove card UE event failed, cardItem is undefined.');
      return;
    }
    const event: ReportCardFaultInformationEvent = {
      faultInformation:HiDfxEventUtil.DIRTY_FORM_STACK_DEGRADATION,
      formId: `${cardItem.cardId}`,
      bundleName: cardItem.bundleName,
      moduleName: `${cardItem.moduleName}`,
      formName: `${cardItem.cardName}`,
      area: cardItem.area ?? [],
      position: FormCommonUtil.getReportPosition(cardItem),
      sourceType: Extend1Data.getCardSourceType(cardItem.extend1),
      formType: FormCommonUtil.getFormType(cardItem.gameCardInfo),
      location: FormLocationType.DESKTOP,
      resultType: ErrorCardResultType.OTHERS,
    };
    HiDfxEventUtil.reportCardFaultInformation(event);
  }

  public static reportClearInvalidCardsId(formList: Array<string>): void {
    const event: ReportCardFaultInformationEvent = {
      faultInformation: HiDfxEventUtil.CLEAR_INVALID_CARDS,
      formId: ``,
      bundleName: ``,
      moduleName: ``,
      formName: ``,
      area: [],
      position: ``,
      location: FormLocationType.DESKTOP,
      sourceType: '',
      formType: 0,
      resultType: ErrorCardResultType.OTHERS,
      formList: formList,
    };
    HiDfxEventUtil.reportCardFaultInformation(event);
  }

  public static getReportPosition(cardItem: CardItemInfo | GridLayoutItemInfo): string {
    return `[${cardItem.page},${cardItem.column},${cardItem.row}]`;
  }

  /**
   * 判断应用是否安装
   * @param bundleName
   * @returns 是否安装
   */
  private static isAppInstalled(bundleName: string): boolean {
    try {
      let applicationInfo: bundleManager.ApplicationInfo = bundleManager.getApplicationInfoSync(bundleName,
        bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT);
      return !!applicationInfo;
    } catch (error) {
      log.showError(`get app installed error: ${error?.code}, ${error?.message}`);
    }
    return false;
  }

  private static fillCacheDataToRDB(cacheData: Array<GridLayoutItemInfo>): void {
    cacheData.map((cacheItem) => {
      if (cacheItem.container === DESKTOP_CONTAINER) {
        log.showWarn(`fill cache form to rdb, formId ${cacheItem.cardId}`);
        const cardItemInfo = new CardItemInfo();
        cardItemInfo.cardId = cacheItem.cardId ?? '';
        cardItemInfo.cardName = cacheItem.cardName ?? '';
        cardItemInfo.appName = cacheItem.appName;
        cardItemInfo.bundleName = cacheItem.bundleName;
        cardItemInfo.abilityName = cacheItem.abilityName;
        cardItemInfo.moduleName = cacheItem.moduleName ?? '';
        cardItemInfo.formConfigAbility = cacheItem.formConfigAbility;
        cardItemInfo.appLabelId = cacheItem.appLabelId;
        cardItemInfo.cardDimension = cacheItem.cardDimension ?? 1;
        cardItemInfo.isTransparent = cacheItem.isTransparent !== undefined ? cacheItem.isTransparent : false;
        cardItemInfo.extend1 = cacheItem.extend1;
        cardItemInfo.container = cacheItem.container;
        cardItemInfo.page = cacheItem.page;
        cardItemInfo.row = cacheItem.row;
        cardItemInfo.column = cacheItem.column;
        FormModel.getInstance().updateFormInfoById(cardItemInfo);
      }
    })
  }
}
