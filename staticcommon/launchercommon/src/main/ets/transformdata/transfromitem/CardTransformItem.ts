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
import {
  CheckEmptyUtils,
  LogDomain,
  Logger
} from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { commonBundleManager } from '@ohos/frameworkwrapper';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { CardItemInfo } from '../../bean/CardItemInfo';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { BackupFavoriteInfo } from '../../model/BackupFavoriteInfo';
import { FormModel } from '../../model/FormModel';
import { IntentParseUtil, PackageRelation } from '../../utils/IntentParseUtil';
import { TransferFormRelationModel } from '../TransferFormRelationModel';
import { BaseTransformItem } from './BaseTransformItem';
import bundleManager from '@ohos.bundle.bundleManager';
import DataConvert from '../DataConvert';
import { FormManager } from '../../manager/FormManager';
import { AppReserveType, CardSourceType, Extend1Data, FormConstants } from '../../TsIndex';
import { LocalHapMigrateInfo, TransformAppInfoManager } from '../../TsIndex';
import { CloneItemInfoManager } from '../manager/CloneItemInfoManager';
import { FormRelationManager } from '../FormRelationManager';
import { AddCardToNewPageManager } from '../manager/AddCardToNewPageManager';
import { Extend1DataKeyEnum, IExtend1DataKey } from '../../bean/Extend1Data';

const TAG = 'CardTransformItem';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);
const INTENT_COMPONENT_KEY: string = 'component';
const KEY_MODULE_NAME = 'ohos.extra.param.key.module_name';
const TOTEMWEATHER_BUNDLE_NAME = 'com.ohos.totemweather';
const KEY_FORM_NAME = 'ohos.extra.param.key.form_name';
const KEY_FORM_DIMENSION = 'ohos.extra.param.key.form_dimension';
const LAUNCHER_PHONE_MODULE = 'phone_sceneboard';
const LAUNCHER_FORM_ABILITY = 'SceneBoardFormAbility';
const INTENT_PORTFOLIO_ID = 'portfolioId';
const ONEMULFOUR_WEATHER_CARD = 'OneMulFourClockCard';

export class CardTransformItem extends BaseTransformItem {
  public isSupportInohos(): boolean {
    return this.backupInfo.container === CommonConstants.CONTAINER_DESKTOP;
  }

  public async transformBackupInfoToGridInfo(backupTransformItemList: BaseTransformItem [], type: string): Promise<GridLayoutItemInfo[]> {
    let formRelationParamStr: string = this.getFormRelationParamsFromIntent(this.backupInfo.intent);
    AddCardToNewPageManager.getInstance().addCardToNewPageCard(this.backupInfo, formRelationParamStr);
    let cardItem: CardItemInfo | null =
      await this.getCardByFormRelation(this.backupInfo, backupTransformItemList, type, formRelationParamStr);
    DataConvert.incCardCount();
    if (!cardItem) {
      DataConvert.saveMisCardArr(formRelationParamStr);
      log.showWarn(TAG, `double card not match, formRelationParamStr: ${formRelationParamStr}`);
      return [];
    }
    // 系统不迁移语音助手建议场景卡
    let portfolioId = this.getPortfolioId(this.backupInfo.intent);
    if (!CheckEmptyUtils.checkStrIsEmpty(portfolioId)) {
      log.showInfo(TAG, `double card voice is not default, portfolioId: ${portfolioId}`);
      return [];
    }
    // 系统组合卡片上可能存在行列值为-1的卡片不迁移
    if (this.backupInfo.cellX < 0 || this.backupInfo.cellY < 0) {
      log.showInfo(TAG, 'double card is not in panel, cardId=%{public}d', this.backupInfo.id);
      return [];
    }
    return [await this.convertToGridLayoutItemInfo(cardItem, type)];
  }

  protected async convertToGridLayoutItemInfo(cardItem: CardItemInfo, type: string): Promise<GridLayoutItemInfo> {
    let currentAppInfo: AppItemInfo | undefined =
      DataConvert.getAppItemInfoList().find(item => item.bundleName === cardItem.bundleName);
    if (!currentAppInfo) {
      log.showError(TAG, `not find bundlle name from applist ${cardItem.bundleName}`);
      let bundleInfo: bundleManager.BundleInfo | undefined =
        await commonBundleManager.getBundleInfoByBundleName(cardItem.bundleName);
      currentAppInfo = new AppItemInfo();
      if (bundleInfo) {
        currentAppInfo.appLabelId = bundleInfo.appInfo?.labelId;
        currentAppInfo.appIconId = bundleInfo.appInfo?.iconId;
      }
    }
    let transCardInfo: GridLayoutItemInfo = this.buildCardInfo(this.backupInfo, currentAppInfo, cardItem);
    return this.setCardSourceType(transCardInfo, type);
  }

  protected setCardSourceType(item: GridLayoutItemInfo, type: string): GridLayoutItemInfo {
    let sourceType: CardSourceType;
    sourceType = CardSourceType.CLONE_MIGRATE;
    Extend1Data.setCardSourceType(item, sourceType);
    return item;
  }

  protected async getCardByFormRelation(backupInfo: BackupFavoriteInfo, backupTransformItemList: BaseTransformItem[],
    type?: string, formRelationParamStr?: string): Promise<CardItemInfo | null> {
    let formRelationModel: TransferFormRelationModel | null =
      FormRelationManager.getInstance().getFormRelationModelMapByBundleName(formRelationParamStr ?? '');
    if (!formRelationModel) {
      log.warn(TAG, `formRelationModelMap is not exist : ${formRelationParamStr}`);
      return null;
    }
    const cards: CardItemInfo[] = await FormModel.getInstance().getFormsInfoFromMapAndManager(formRelationModel.targetBundleName);
    if (CheckEmptyUtils.isEmptyArr(cards)) {
      // 获取设备应用包名信息
      let packageName: string = this.getAppPackageName(backupInfo, backupTransformItemList);
      if (CheckEmptyUtils.checkStrIsEmpty(packageName)) {
        log.warn(TAG, `back up app package is not exist : ${packageName}`);
        return null;
      }
      // 判断应用是否在迁移服务的可安装应用信息里面
      let preOccupyInfo: LocalHapMigrateInfo | undefined =
        TransformAppInfoManager.getInstance().getMigrateByBundleAndType(packageName, AppReserveType.THIRD);
      if (!preOccupyInfo) {
        log.warn(TAG, `current app is not installable from the migration service, ${formRelationModel.sourceBundleName}`);
        return null;
      }

      log.showInfo(TAG, `not find any card, bundleName ${formRelationModel.targetBundleName}`);
      this.setBackupTitle(backupInfo, backupTransformItemList, formRelationModel.sourceBundleName);
      let placeholderCardId: string = String(DataConvert.incCurrentTime());
      this.saveFormRelation(formRelationModel, backupInfo, placeholderCardId);
      return this.buildSceneBoardDefaultCard(formRelationModel, placeholderCardId);
    }
    let cardItem: CardItemInfo | null = null;
    cards.filter(card => {
      return card.bundleName === formRelationModel?.targetBundleName &&
        card.moduleName === formRelationModel.targetModuleName &&
        card.abilityName === formRelationModel.targetAbilityName &&
        card.cardName === formRelationModel.targetFormName &&
        card.supportDimensions.findIndex(cardDimension => {
          return cardDimension === formRelationModel?.targetFormDimension;
        }) !== CommonConstants.INVALID_VALUE;
    }).forEach(card => {
      if (card.bundleName === TOTEMWEATHER_BUNDLE_NAME ||
        card.dimension <= (formRelationModel?.targetFormDimension ?? 0)) {
        card.dimension = formRelationModel?.targetFormDimension ?? 0;
        card.isFormDimension1x4 = card.cardName === ONEMULFOUR_WEATHER_CARD;
        card.area = FormManager.getInstance().getCardSize(card.dimension, card.isFormDimension1x4);
        card.cardId = String(backupInfo.appWidgetId);
        cardItem = card;
      } else {
        log.showError(TAG, `card size increases, bundleName ${formRelationModel?.sourceBundleName}`);
      }
    });
    return cardItem;
  }

  // 设备卡片/widget的包名和应用包名可能不一致,获取设备应用信息
  private getAppPackageName(backupInfo: BackupFavoriteInfo, backupTransformItemList: BaseTransformItem[]): string {
    if (CheckEmptyUtils.checkStrIsEmpty(backupInfo.title)) {
      // widget,从intent中取包名
      let packageRelation: PackageRelation | null = IntentParseUtil.getComponentByIntent(backupInfo.intent);
      if (packageRelation) {
        log.showInfo(TAG, `getAppPackageName widget: ${packageRelation.packageName}`);
        return packageRelation.packageName;
      }
    } else {
      // card,根据title和应用查询包名
      let backupAppInfo: BaseTransformItem | undefined = backupTransformItemList.find(backupFavoriteInfo => {
        return backupFavoriteInfo.backupInfo.itemType === CommonConstants.TYPE_APP && backupFavoriteInfo.backupInfo.title === backupInfo.title;
      });
      if (!backupAppInfo) {
        return '';
      }
      let packageRelation: PackageRelation | null = IntentParseUtil.getComponentByIntent(backupAppInfo.backupInfo.intent);
      if (packageRelation) {
        log.showInfo(TAG, `getAppPackageName card: ${packageRelation.packageName}`);
        return packageRelation.packageName;
      }
    }
    return '';
  }

  protected buildCardInfo(backupInfo: BackupFavoriteInfo, appItemInfo: AppItemInfo | undefined,
    cardItem: CardItemInfo): GridLayoutItemInfo {
    let item: GridLayoutItemInfo = this.buildGridInfoByBackupInfo(backupInfo);
    item.appIconId = appItemInfo?.appIconId ?? 0;
    item.appLabelId = appItemInfo?.appLabelId;
    item.bundleName = cardItem.bundleName;
    item.abilityName = cardItem.abilityName;
    item.moduleName = cardItem.moduleName;
    item.area = cardItem.area;
    item.cardName = cardItem.cardName;
    item.isTransparent = cardItem.isTransparent;
    item.page = backupInfo.screen;
    item.typeId = CommonConstants.TYPE_CARD;
    item.formConfigAbility = cardItem.formConfigAbility;
    item.cardId = cardItem.cardId;
    if (!item.cardId || item.cardId === String(NumberConstants.CONSTANT_NUMBER_ZERO)) {
      let intentMap: Map<string, string> = IntentParseUtil.parseIntent(backupInfo.intent);
      let cardId = intentMap.get(FormConstants.ID_PARAM);
      item.cardId =
        (cardId === String(NumberConstants.CONSTANT_NUMBER_ZERO) || !cardId) ? String(DataConvert.incCurrentTime()) :
          cardId;
      log.showInfo(TAG, 'cardId is undefined or zero, bundleName = %{public}s newCardId = %{public}s', item.bundleName,
        item.cardId);
    }
    item.extend1 = JSON.stringify({ parameters:
      { [Extend1DataKeyEnum.OHOS_EXTRA_PARAM_KEY_MIGRATE_FORM]: true } as  Record<string, boolean> });
    log.showWarn(TAG, `double card is ${item.cardName}, ${item.bundleName}, ${item.moduleName}, ${item.abilityName}, ` +
      `${item.cardId}, [${item.area?.[0]}*${item.area?.[1]}], ${cardItem.description} --- screen : ${item.page}, ` +
      `container: ${item.container}, point : [${item.row}, ${item.column}] : isTransparent : ${item.isTransparent}`);
    return item;
  }

  /**
   * 获取映射关系唯一字串
   * @param intent 设备数据库intent字段
   * @returns 卡片映射关系唯一字串
   */
  protected getFormRelationParamsFromIntent(intent: string): string {
    let result = '';
    let intentMap: Map<string, string> = IntentParseUtil.parseIntent(intent);
    if (!intentMap) {
      return result;
    }
    let packageRelation: PackageRelation | null = IntentParseUtil.getByRelationComponentStr(
      intentMap.get(INTENT_COMPONENT_KEY) ?? '');
    if (!packageRelation) {
      return result;
    }
    result += packageRelation.packageName + ':';
    result += (intentMap.get(KEY_MODULE_NAME) ?? '') + ':';
    result += packageRelation.className + ':';
    result += (intentMap.get(KEY_FORM_NAME) ?? '') + ':';
    result += intentMap.get(KEY_FORM_DIMENSION) ?? 0;
    log.showWarn(TAG, `getFormRelationParamsFromIntent => ${result}`);
    return result;
  }

  private setBackupTitle(backupInfo: BackupFavoriteInfo, backupTransformItemList: BaseTransformItem [], sourceBundleName: string): void {
    if (!CheckEmptyUtils.checkStrIsEmpty(backupInfo.title)) {
      return;
    }
    let backupAppInfo: BaseTransformItem | undefined = backupTransformItemList.find(backupFavoriteInfo => {
      return backupFavoriteInfo.backupInfo.itemType === CommonConstants.TYPE_APP && backupFavoriteInfo.backupInfo.intent.includes(sourceBundleName);
    });
    if (backupAppInfo) {
      log.showInfo(TAG, `set widget name : ${backupAppInfo.backupInfo.title}`);
      backupInfo.title = backupAppInfo.backupInfo.title;
    }
  }

  private buildSceneBoardDefaultCard(formRelationModel: TransferFormRelationModel,
    placeholderCardId: string): CardItemInfo {
    let cardItem: CardItemInfo = new CardItemInfo();
    cardItem.bundleName = CommonConstants.LAUNCHER_BUNDLE;
    cardItem.moduleName = LAUNCHER_PHONE_MODULE;
    cardItem.abilityName = LAUNCHER_FORM_ABILITY;
    cardItem.cardDimension = formRelationModel.targetFormDimension;
    cardItem.area = FormManager.getInstance().getCardSize(formRelationModel.targetFormDimension);
    cardItem.isTransparent = false;
    cardItem.cardName = FormRelationManager.getInstance().getSceneBoardFormName(formRelationModel.targetFormDimension);
    cardItem.cardId = placeholderCardId;
    log.showInfo(TAG, `buildSceneBoardDefaultCard : ${cardItem.bundleName} : ${cardItem.moduleName} :  ` +
      `${cardItem.abilityName} : ${cardItem.cardName}`);
    return cardItem;
  }

  private async saveFormRelation(formRelationModel: TransferFormRelationModel, backupInfo: BackupFavoriteInfo,
    placeholderCardId: string): Promise<void> {
    let relationCardItems: CardItemInfo[] =
      FormRelationManager.getInstance().getSceneBoardFormRelationByBundleName(formRelationModel.targetBundleName);
    relationCardItems.push(this.createRelationModel(formRelationModel, backupInfo, placeholderCardId));
    FormRelationManager.getInstance().setSceneBoardFormRelation(formRelationModel.targetBundleName, relationCardItems);
  }

  private createRelationModel(formRelationModel: TransferFormRelationModel, backupInfo: BackupFavoriteInfo,
    placeholderCardId: string): CardItemInfo {
    let cardItem: CardItemInfo = new CardItemInfo();
    cardItem.bundleName = formRelationModel.targetBundleName;
    cardItem.moduleName = formRelationModel.targetModuleName;
    cardItem.abilityName = formRelationModel.targetAbilityName;
    cardItem.cardName = formRelationModel.targetFormName;
    cardItem.cardDimension = formRelationModel.targetFormDimension;
    cardItem.cardId = placeholderCardId;
    cardItem.thirdAppRelationCardId = String(backupInfo.appWidgetId);
    cardItem.appName = backupInfo.title;
    return cardItem;
  }

  private getPortfolioId(intent: string): string | undefined {
    let intentMap: Map<string, string> = IntentParseUtil.parseIntent(intent);
    if (!intentMap) {
      return undefined;
    }
    return intentMap.get(INTENT_PORTFOLIO_ID);
  }
}