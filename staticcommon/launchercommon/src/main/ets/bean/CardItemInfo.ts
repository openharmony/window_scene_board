/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import type rdb from '@ohos.data.relationalStore';
import GridLayoutInfoColumns, { GridLayoutInfoEnums } from '../db/column/GridLayoutInfoColumns';
import { CommonConstants } from '../constants/CommonConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { launcherStatusUtil } from '@ohos/windowscene';
import { commonBundleManager } from '@ohos/frameworkwrapper';
import GridLayoutItemInfo from './GridLayoutItemInfo';
import { GameCardInfo } from './GameCardInfo';
import { FullScreenCardUtil } from '../form/model/FullScreenCardUtil';
import { OverflowFormInfoUtil } from '../utils/OverflowFormInfoUtil';
import { ShortcutInfo } from './ReceiveEventInfo';

const CARD_SIZE_LENGTH = 2;
const CARD_SIZE_MIDDLE_LENGTH = 2;
const CARD_SIZE_SMALL_LENGTH = 1;
const CARD_SIZE_LARGE_LENGTH = 4;
const CARD_SIZE_LARGER_LENGTH = FullScreenCardUtil.getInstance().getRow();
const CARD_SIZE_LARGE_LENGTH_SAMPLE = 3;
const CARD_SIZE_ONE_TWO: number[] = [CARD_SIZE_MIDDLE_LENGTH, CARD_SIZE_SMALL_LENGTH];
const CARD_SIZE_TWO_TWO: number[] = [CARD_SIZE_MIDDLE_LENGTH, CARD_SIZE_MIDDLE_LENGTH];
const CARD_SIZE_ONE_FOUR: number[] = [CARD_SIZE_LARGE_LENGTH, CARD_SIZE_SMALL_LENGTH];
const CARD_SIZE_TWO_FOUR: number[] = [CARD_SIZE_LARGE_LENGTH, CARD_SIZE_MIDDLE_LENGTH];
const CARD_SIZE_FOUR_FOUR: number[] = [CARD_SIZE_LARGE_LENGTH, CARD_SIZE_LARGE_LENGTH];
const CARD_SIZE_SIX_FOUR: number[] = [CARD_SIZE_LARGE_LENGTH, CARD_SIZE_LARGER_LENGTH];
const CARD_SIZE_TWO_THREE: number[] = [CARD_SIZE_LARGE_LENGTH_SAMPLE, CARD_SIZE_MIDDLE_LENGTH];
const FORM_TRANSPARENT: string = '1';
const FORM_OPAQUE: string = '0';

const TAG = 'CardItemInfo';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
/**
 * Indicates form info
 */
export class CardItemInfo {
  public id: string | undefined;

  public container: number | undefined;

  public name: string | undefined;

  public readonly typeId: number = CommonConstants.TYPE_CARD;

  /**
   * Indicates form id
   */
  public cardId: string = '';

  /**
   * Indicates form bundleName.
   */
  public bundleName: string = '';

  /**
   * Indicates form abilityName.
   */
  public abilityName: string = '';

  /**
   * Indicates form moduleName.
   */
  public moduleName: string = '';

  /**
   * Indicates app moduleName.
   */
  public mainModuleName: string = '';

  /**
   * Indicates cardName.
   */
  public cardName: string = '';

  /**
   * Indicates form dimension.
   */
  public cardDimension: number = CommonConstants.CARD_DIMENSION_1x2;

  /**
   * Indicates form size.
   */
  public area: number[] | undefined;

  /**
   * Indicates form description.
   */
  public description: string = '';

  /**
   * Indicates form formConfigAbility.
   */
  public formConfigAbility: string | undefined;

  /**
   * Indicates form of app labelId.
   */
  public appLabelId: number | undefined;

  /**
   * Indicates form of app name.
   */
  public appName: string | undefined;

  /**
   * Indicates form of support Dimensions.
   */
  public supportDimensions: number[] = [];

  /**
   * GridLayoutItemInfo: page
   */
  public page: number | undefined;

  /**
   * GridLayoutItemInfo: column of positons
   */
  public column: number | undefined;

  /**
   * GridLayoutItemInfo: row of positons
   */
  public row: number | undefined;

  /**
   * App area type: desktop = 0, dock = 1, app center = 2
   */
  public areaType: number | undefined;

  /**
   * GridLayoutItemInfo: totle count of card
   */
  public totleDimensionCount: number | undefined;

  /**
   * Indicates form transparency
   */
  public isTransparent: boolean = false;

  /**
   * Indicates if card show in outer home formCenter.
   */
  public isOuterHomeDisable: boolean = false;

  /**
   * Obtains the displayName resource id of this form.
   *
   * @type { number }
   */
  public displayNameId: number = 0;

  public dimension: number = 0;
  public dragLayerWidth: number = 0;
  public dragLayerHeight: number = 0;
  public descriptionId: number = 0;

  /**
   * Indicates if card show in formCenter.
   */
  public showInCenter: boolean = true;

  /**
   * Indicates if card is default activated.
   */
  public isDefaultActivated: boolean = false;

  /**
   * Indicates if card is weather designed.
   */
  public isFormDimension1x4: boolean = false;

  /**
   * Indicates the card rendering mode
   */
  public renderingMode: number = 0;

  /**
   * Indicates applicationName.
   */
  public applicationName?: string;

  /**
   * Indicates applicationIconId.
   */
  public applicationIconId?: number;

  /**
   * Indicates applicationLabelId.
   */
  public applicationLabelId?: number;

  /**
   * Indicates appIconId
   */
  public appIconId?: number;

  /**
   * GridLayoutItemInfo: extend1 of card
   */
  public extend1?: string | undefined;

  /**
   * GridLayoutItemInfo: extend2 of card
   */
  public extend2?: string | undefined;

  /**
   * Indicates the bundle name of the external caller
   */
  public callerBundle?: string | undefined;

  /**
   * 三方应用映射卡片id
   */
  public thirdAppRelationCardId?: string | undefined;

  public intent?: string = '';

  public gameCardInfo?: GameCardInfo;

  /**
   * form center card row
   */
  public formRow?: number;

  /**
   * form center card column
   */
  public formColumn?: number;

  /**
   * for lazy rotate
   */
  public landscapeRow?: number;

  /**
   * for lazy rotate
   */
  public landscapeColumn?: number;

  /**
   * for lazy rotate
   */
  public landscapePage?: number;

  /**
   * for lazy rotate
   */
  public landscapeArea?: number[];

  /**
   * for lazy rotate
   */
  public portraitRow?: number;

  /**
   * for lazy rotate
   */
  public portraitColumn?: number;

  /**
   * for lazy rotate
   */
  public portraitPage?: number;

  /**
   * for lazy rotate
   */
  public portraitArea?: number[];

  /**
   * temp card id
   */
  public tempId?: string;

  /**
   * enableBlurBackground
   */
  public enableBlurBgr?: boolean;

  /**
   * resizeable
   */
  public resizable?: boolean;

  /**
   * groupId
   */
  public groupId?: string;

  /**
   * is default card
   */
  public isDefaultCardDimension?: number;

  public targetFormData?: string;

  public targetDescription?: string;

  public targetLabel?: string;

  shortcutInfo?: ShortcutInfo;

  keyName?: string;

  constructor() {
  }

  /**
   * convert from resultSet
   *
   * @param resultSet data from db
   * @returns CardItemInfo
   */
  public fromResultSet(resultSet: rdb.ResultSet): CardItemInfo {
    if (resultSet != null) {
      this.cardId = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INFO_ID));
      this.cardName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INFO_NAME));
      this.bundleName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.BUNDLE_NAME));
      this.abilityName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ABILITY_NAME));
      this.moduleName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.MODULE_NAME));
      this.formConfigAbility = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.URI));
      this.appLabelId = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_LABEL_ID));
      this.container = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.CONTAINER));
      this.area = [
        resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.WIDTH)),
        resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.HEIGHT))
      ];
      this.cardDimension = CardItemInfo.getCardDimension(this.area);
      this.page = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.PAGE_INDEX));
      this.column = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.COLUMN));
      this.row = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ROW));

      // 双缓存机制
      this.portraitPage = this.getNumberByCol(resultSet, GridLayoutInfoColumns.PORTRAIT_PAGE_INDEX);
      this.portraitColumn = this.getNumberByCol(resultSet, GridLayoutInfoColumns.PORTRAIT_COLUMN);
      this.portraitRow = this.getNumberByCol(resultSet, GridLayoutInfoColumns.PORTRAIT_ROW);
      this.landscapePage = this.getNumberByCol(resultSet, GridLayoutInfoColumns.LANDSCAPE_PAGE_INDEX);
      this.landscapeColumn = this.getNumberByCol(resultSet, GridLayoutInfoColumns.LANDSCAPE_COLUMN);
      this.landscapeRow = this.getNumberByCol(resultSet, GridLayoutInfoColumns.LANDSCAPE_ROW);
      let portraitWidth = this.getNumberByCol(resultSet, GridLayoutInfoColumns.PORTRAIT_WIDTH);
      if (Number.isNaN(portraitWidth)) {
        portraitWidth = this.area[0];
      }
      let portraitHeight = this.getNumberByCol(resultSet, GridLayoutInfoColumns.PORTRAIT_HEIGHT);
      if (Number.isNaN(portraitHeight)) {
        portraitHeight = this.area[1];
      }
      this.portraitArea = [portraitWidth, portraitHeight];
      let landscapeWidth = this.getNumberByCol(resultSet, GridLayoutInfoColumns.LANDSCAPE_WIDTH);
      if (Number.isNaN(landscapeWidth)) {
        landscapeWidth = this.area[0];
      }
      let landscapeHeight = this.getNumberByCol(resultSet, GridLayoutInfoColumns.LANDSCAPE_HEIGHT);
      if (Number.isNaN(landscapeHeight)) {
        landscapeHeight = this.area[1];
      }
      this.landscapeArea = [landscapeWidth, landscapeHeight];

      this.formConfigAbility = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.URI));
      this.extend1 = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.EXTEND1));
      this.extend2 = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.EXTEND2));
      this.isTransparent = this.extend2 === FORM_TRANSPARENT;
      let targetFormDataIndex: number = this.getNumberByCol(resultSet, GridLayoutInfoColumns.TARGET_FORM_DATA);
      if (Number.isNaN(targetFormDataIndex)) {
        this.targetFormData = resultSet.getString(targetFormDataIndex);
      } else {
        this.targetFormData = '';
      }
      this.intent = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INTENT));
      this.gameCardInfo = OverflowFormInfoUtil.parseLiveFormCardInfo(this.intent);
    } else {
      log.showError(`fromResultSet error, null resultSet: ${resultSet}`);
    }
    return this;
  }

  /**
   * 获取卡片网格样式
   * {@link @ohos.app.form.formInfo.defaultDimension}
   *
   * @param area 卡片区域信息[宽, 高]
   * @returns 卡片网格样式
   */
  public static getCardDimension(area: number[]): number {
    if (!area || area.length !== CARD_SIZE_LENGTH) {
      log.showError(`getCardDimension by invalid area failed, area: ${area}`);
      return CommonConstants.CARD_DIMENSION_2x2;
    }
    if (area[0] === CARD_SIZE_ONE_TWO[0] && area[1] === CARD_SIZE_ONE_TWO[1]) {
      return CommonConstants.CARD_DIMENSION_1x2;
    } else if (area[0] === CARD_SIZE_TWO_TWO[0] && area[1] === CARD_SIZE_TWO_TWO[1]) {
      return CommonConstants.CARD_DIMENSION_2x2;
    } else if (area[0] === CARD_SIZE_TWO_FOUR[0] && (area[1] === CARD_SIZE_TWO_FOUR[1] || area[1] === CARD_SIZE_SMALL_LENGTH)) {
      return CommonConstants.CARD_DIMENSION_2x4;
    } else if (area[0] === CARD_SIZE_FOUR_FOUR[0] && area[1] === CARD_SIZE_FOUR_FOUR[1]) {
      return CommonConstants.CARD_DIMENSION_4x4;
    } else if (area[0] === CARD_SIZE_SIX_FOUR[0] && FullScreenCardUtil.getInstance().getAllRows().includes(area[1])) {
      return CommonConstants.CARD_DIMENSION_6x4;
    } else {
      log.showError(`getCardDimension by area failed, wrong area: ${area}`);
      return CommonConstants.CARD_DIMENSION_2x2;
    }
  }

  /**
   * 获取卡片布局信息
   *
   * @param dimension 卡片大小
   * @returns 卡片布局信息 [宽, 高]
   */
  public static getCardSize(dimension: number, isFormDimension1x4?: boolean): number[] {
    if (isFormDimension1x4) {
      log.showInfo('card isFormDimension1x4 true');
      return CARD_SIZE_ONE_FOUR;
    }
    if (launcherStatusUtil.getSimpleModeStatus()) {
      return CARD_SIZE_TWO_THREE;
    }
    if (dimension === CommonConstants.CARD_DIMENSION_1x2) {
      return CARD_SIZE_ONE_TWO;
    } else if (dimension === CommonConstants.CARD_DIMENSION_2x2) {
      return CARD_SIZE_TWO_TWO;
    } else if (dimension === CommonConstants.CARD_DIMENSION_2x4) {
      return CARD_SIZE_TWO_FOUR;
    } else if (dimension === CommonConstants.CARD_DIMENSION_4x4) {
      return CARD_SIZE_FOUR_FOUR;
    } else if (dimension === CommonConstants.CARD_DIMENSION_6x4) {
      return CARD_SIZE_SIX_FOUR;
    } else {
      log.showError(`CardItemInfo getCardSize by dimension failed, wrong dimension: ${dimension}`);
      return CARD_SIZE_TWO_TWO;
    }
  }

  /**
   * convert to valuesBucket
   *
   * @param cardItemInfo cardItemInfo
   * @returns ValuesBucket
   */
  public static toValuesBucket(cardItemInfo: CardItemInfo | GridLayoutItemInfo, screenId?: number): rdb.ValuesBucket {
    if (cardItemInfo === null || cardItemInfo === undefined) {
      log.showError('toValuesBucket error, invalid cardItemInfo');
      return {};
    }
    if (cardItemInfo.cardDimension === undefined) {
      log.showWarn(`toValuesBucket: ${JSON.stringify(cardItemInfo)}`);
      return {};
    }
    let cardSize = CardItemInfo.getCardSize(cardItemInfo.cardDimension, cardItemInfo.isFormDimension1x4);
    let width = cardSize[0];
    let height = cardSize[1];
    log.showInfo('toValuesBucket cardId:%{public}s, dimension:%{public}d, width:%{public}d, height:%{public}d',
      cardItemInfo.cardId, cardItemInfo.cardDimension, width, height);
    return {
      [GridLayoutInfoEnums.INFO_ID]: cardItemInfo.cardId,
      [GridLayoutInfoEnums.INFO_NAME]: cardItemInfo.cardName,
      [GridLayoutInfoEnums.BUNDLE_NAME]: cardItemInfo.bundleName,
      [GridLayoutInfoEnums.ABILITY_NAME]: cardItemInfo.abilityName,
      [GridLayoutInfoEnums.MODULE_NAME]: cardItemInfo.moduleName,
      [GridLayoutInfoEnums.URI]: cardItemInfo.formConfigAbility,
      [GridLayoutInfoEnums.APP_LABEL_ID]: cardItemInfo.appLabelId,
      [GridLayoutInfoEnums.WIDTH]: width,
      [GridLayoutInfoEnums.HEIGHT]: height,
      [GridLayoutInfoEnums.CONTAINER]: CommonConstants.CONTAINER_DESKTOP,
      [GridLayoutInfoEnums.TYPE_ID]: cardItemInfo.typeId,
      [GridLayoutInfoEnums.PAGE_INDEX]: cardItemInfo.page,
      [GridLayoutInfoEnums.COLUMN]: cardItemInfo.column,
      [GridLayoutInfoEnums.ROW]: cardItemInfo.row,
      [GridLayoutInfoEnums.PORTRAIT_PAGE_INDEX]: cardItemInfo.portraitPage,
      [GridLayoutInfoEnums.PORTRAIT_COLUMN]: cardItemInfo.portraitColumn,
      [GridLayoutInfoEnums.PORTRAIT_ROW]: cardItemInfo.portraitRow,
      [GridLayoutInfoEnums.PORTRAIT_WIDTH]: cardItemInfo.portraitArea?.[0] ?? width,
      [GridLayoutInfoEnums.PORTRAIT_HEIGHT]: cardItemInfo.portraitArea?.[1] ?? height,
      [GridLayoutInfoEnums.LANDSCAPE_PAGE_INDEX]: cardItemInfo.landscapePage,
      [GridLayoutInfoEnums.LANDSCAPE_COLUMN]: cardItemInfo.landscapeColumn,
      [GridLayoutInfoEnums.LANDSCAPE_ROW]: cardItemInfo.landscapeRow,
      [GridLayoutInfoEnums.LANDSCAPE_WIDTH]: cardItemInfo.landscapeArea?.[0] ?? width,
      [GridLayoutInfoEnums.LANDSCAPE_HEIGHT]: cardItemInfo.landscapeArea?.[1] ?? height,
      [GridLayoutInfoEnums.USER_ID]: commonBundleManager.getUserId(),
      [GridLayoutInfoEnums.EXTEND1]: cardItemInfo.extend1,
      [GridLayoutInfoEnums.EXTEND2]: cardItemInfo.isTransparent ? FORM_TRANSPARENT : FORM_OPAQUE,
      [GridLayoutInfoEnums.APP_INDEX]: 0,
      [GridLayoutInfoEnums.INTENT]: cardItemInfo.intent ?? '',
      [GridLayoutInfoEnums.SHORTCUT_ID]: '',
      // 增加主题字段配置
      [GridLayoutInfoEnums.TARGET_FORM_DATA]: cardItemInfo.targetFormData,
      [GridLayoutInfoEnums.SCREEN_ID]: screenId ?? 0,
    };
  }

  private getNumberByCol(resultSet: rdb.ResultSet, colName: string): number {
    try {
      let index: number = resultSet.getColumnIndex(colName);
      return resultSet.getLong(index);
    } catch (error) {
      log.showError(`getNumberByCol error: ${error?.message}`);
    }
    return NaN;
  }
}