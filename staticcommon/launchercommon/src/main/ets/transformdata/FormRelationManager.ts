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

import fs from '@ohos.file.fs';
import type ctx from '@ohos.app.ability.common';
import {
  CheckEmptyUtils,
  FileUtils,
  LogDomain,
  Logger,
} from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { CardItemInfo } from '../bean/CardItemInfo';
import { CommonConstants } from '../constants/CommonConstants';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { TransferFormRelationModel } from './TransferFormRelationModel';
import ConfigParseUtil from '../utils/ConfigParseUtil';

const TAG = 'FormRelationManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const CONFIG = 'etc/form_mapping_relation_table.json';
const FORM_MAPPING_RELATION_TABLE_CLOUD_PATH = '/data/storage/el2/backup/restore/cloudConfig/';
const FORM_MAPPING_RELATION_TABLE = 'form_mapping_relation_table.json';
const SCENE_BOARD_FORM_DIMENSION_2_1 = 1;
const SCENE_BOARD_FORM_DIMENSION_2_2 = 2;
const SCENE_BOARD_FORM_DIMENSION_2_4 = 3;
const SCENE_BOARD_FORM_DIMENSION_4_4 = 4;
const CardGridWidth_2 = 2;
const CardGridWidth_4 = 4;
const CardGridHeight_1 = 1;
const CardGridHeight_2 = 2;
const CardGridHeight_4 = 4;

// 克隆占位卡名称
const SCENE_BOARD_FORM_NAME_MAP: Map<number, string> = new Map([
  [SCENE_BOARD_FORM_DIMENSION_2_1, 'SceneBoard_2_1_Card'],
  [SCENE_BOARD_FORM_DIMENSION_2_2, 'SceneBoard_2_2_Card'],
  [SCENE_BOARD_FORM_DIMENSION_2_4, 'SceneBoard_2_4_Card'],
  [SCENE_BOARD_FORM_DIMENSION_4_4, 'SceneBoard_4_4_Card']
]);

/**
 * 占位卡片关系/系统卡片关系管理类
 * 负责克隆产生的占位卡片映射信息的管理，以及系统卡片对应关系的管理
 *
 * 克隆进程向此管理类存储数据并持久化，桌面进程从此管理类读取数据并显示占位卡信息
 *
 * @since 2024/12/27
 */
export class FormRelationManager {
  private static instance: FormRelationManager;
  // 系统卡片映射关系，key为包名，value为此包名下卡片系统的映射关系
  private formRelationModelMap: Map<string, TransferFormRelationModel> = new Map();

  // 未安装应用的占位卡关联映射  key:应用包名  value:应用的占位卡片信息集合
  private sceneBoardFormRelationModelMap: Map<string, CardItemInfo[]> = new Map();

  private constructor() {
  }

  public static getInstance(): FormRelationManager {
    if (!FormRelationManager.instance) {
      FormRelationManager.instance = new FormRelationManager();
    }
    return FormRelationManager.instance;
  }

  /**
   * 从持久化文件中初始化映射关系
   */
  public initSceneBoardFormRelation(): void {
    if (this.sceneBoardFormRelationModelMap.size > 0) {
      return;
    }
    try {
      let sceneBoardFormRelationFilePath = (GlobalContext.getInstance().getObject('desktopContext') as
        ctx.ServiceExtensionContext).filesDir + '/' + CommonConstants.SCENE_BOARD_FORM_RELATION_INFO;
      if (!FileUtils.isExist(sceneBoardFormRelationFilePath)) {
        log.showWarn(TAG, 'sceneBoardFormRelationFilePath is not exist');
        return;
      }
      const formRelationFile = fs.readTextSync(sceneBoardFormRelationFilePath);
      if (CheckEmptyUtils.checkStrIsEmpty(formRelationFile)) {
        log.showWarn(TAG, `read formRelationFile is empty`);
        return;
      }
      let jsonArray: [string, CardItemInfo[]][] = JSON.parse(formRelationFile);
      if (Array.isArray(jsonArray)) {
        this.sceneBoardFormRelationModelMap = new Map(jsonArray);
      }
    } catch (error) {
      log.showError(TAG, `readTextSync error: ${error.msg}`);
      return;
    }
    log.showWarn(TAG, `initSceneBoardFormRelation map.size: ${this.sceneBoardFormRelationModelMap.size}`);
  }

  /**
   * 系统迁移/系统迁移结束后保存未恢复占位卡片映射到文件
   * 并且清除系统迁移后的多余卡片映射文件（不可能出现两次系统迁移，此路径可删除）
   */
  public async dealWithFormRelationInfo(): Promise<void> {
    log.showInfo(TAG, `dealWithFormRelationInfo start`);
    try {
      let filesDir = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).filesDir;
      FileUtils.writeStringToFile(JSON.stringify(Array.from(this.sceneBoardFormRelationModelMap)),
        filesDir + '/' + CommonConstants.SCENE_BOARD_FORM_RELATION_INFO);
      if (FileUtils.isExist(filesDir + '/' + FORM_MAPPING_RELATION_TABLE)) {
        FileUtils.deleteConfigFile(filesDir + '/' + FORM_MAPPING_RELATION_TABLE);
      }
    } catch (e) {
      log.showError(TAG, `dealWithFormRelationInfo error: ${e.message}`);
    }
  }

  /**
   * 刷新并持久化占位卡映射关系到json文件
   */
  public refreshSceneBoardFormRelationToFile(): void {
    try {
      let sceneBoardFormRelationFilePath =
        (GlobalContext.getInstance().getObject('desktopContext') as
        ctx.ServiceExtensionContext).filesDir + '/' + CommonConstants.SCENE_BOARD_FORM_RELATION_INFO;
      if (this.sceneBoardFormRelationModelMap.size === 0 && FileUtils.isExist(sceneBoardFormRelationFilePath)) {
        FileUtils.deleteConfigFile(sceneBoardFormRelationFilePath);
        return;
      }
      FileUtils.writeStringToFile(JSON.stringify(Array.from(this.sceneBoardFormRelationModelMap)),
        sceneBoardFormRelationFilePath);
    } catch (e) {
      log.showError(TAG, `refreshSceneBoardFormRelationToFile error: ${e.message}`);
    }
  }

  /**
   * 根据CardId从SceneBoard卡片关系映射中获取应用名称
   * 桌面进程调用函数时需要从文件中同步占位卡信息
   *
   * @param cardId 卡片ID
   * @returns appName 应用名称
   */
  public getAppNameByCardId(cardId: string): string {
    log.showInfo(TAG, `getAppNameByCardId: ${cardId}`);
    this.initSceneBoardFormRelation();
    for (let cardItems of this.sceneBoardFormRelationModelMap.values()) {
      for (let cardItem of cardItems) {
        if (cardItem.cardId === cardId && cardItem.appName !== undefined) {
          log.showInfo(TAG, `setRealAppName: ${cardItem.appName}`);
          return cardItem.appName;
        }
      }
    }
    return '';
  }

  /**
   * 根据卡片id删除SceneBoard映射关系文件中的数据
   * 桌面进程调用函数时需要从文件中同步占位卡信息
   *
   * @param cardId 删除的卡片ID
   */
  public deleteSceneBoardFormRelationMapByCardId(cardId: string): void {
    this.initSceneBoardFormRelation();
    for (let cardItemEntry of this.sceneBoardFormRelationModelMap.entries()) {
      const formIndex = cardItemEntry[1].findIndex((cardItem) => {
        return cardItem.cardId === cardId;
      });
      if (formIndex !== CommonConstants.INVALID_VALUE) {
        log.showInfo(TAG, `delete cardId: ${cardId}`);
        cardItemEntry[1].splice(formIndex, 1);
        if (cardItemEntry[1].length === 0) {
          this.sceneBoardFormRelationModelMap.delete(cardItemEntry[0]);
        }
        break;
      }
    }
    this.refreshSceneBoardFormRelationToFile();
  }

  /**
   * 根据bundleName删除SceneBoard映射关系文件中的数据
   * 桌面进程调用函数时需要从文件中同步占位卡信息
   *
   * @param bundleName 应用包名
   */
  public deleteSceneBoardFormRelationMapByBundleName(bundleName: string): void {
    this.initSceneBoardFormRelation();
    this.sceneBoardFormRelationModelMap.delete(bundleName);
    log.showInfo(TAG, `deleteSceneBoardFormRelationMapByBundleName map.size: ${this.sceneBoardFormRelationModelMap.size}`);
    this.refreshSceneBoardFormRelationToFile();
  }

  /**
   * 删除应用时删除对应的卡片信息
   * 桌面进程调用函数时需要从文件中同步占位卡信息
   *
   * @param bundleName 删除应用的包名
   * @param layoutInfo 卡片和堆叠信息
   * @param remainingStackInfos 需要保留的卡片信息
   * @param deleteStackInfos 需要删除的卡片和堆叠信息
   */
  public deleteSceneBoardFormRelationInfoByBundleName(bundleName: string, layoutInfo: GridLayoutItemInfo[],
    remainingStackInfos: GridLayoutItemInfo[], deleteFormAndStackInfos: GridLayoutItemInfo[]): void {
    log.showInfo(TAG, `deleteSceneBoardFormRelationInfoByBundleName: ${bundleName}`);
    this.initSceneBoardFormRelation();
    if (!this.sceneBoardFormRelationModelMap.has(bundleName)) {
      return;
    }
    let relationCards: CardItemInfo[] | undefined = this.sceneBoardFormRelationModelMap.get(bundleName);
    if (!relationCards || CheckEmptyUtils.isEmptyArr(relationCards)) {
      log.showWarn(TAG, 'empty stack');
      return;
    }
    log.showInfo(TAG, `relationCards.length: ${relationCards.length}`);
    // 修改缓存
    for (let i = layoutInfo.length - 1; i >= 0; i--) {
      if (layoutInfo[i].typeId === CommonConstants.TYPE_CARD) {
        this.collectDeleteCardLayoutInfo(relationCards, layoutInfo[i], deleteFormAndStackInfos);
      } else if (layoutInfo[i].typeId === CommonConstants.TYPE_FORM_STACK) {
        this.collectDeleteStackLayoutInfo(relationCards, layoutInfo[i], remainingStackInfos, deleteFormAndStackInfos);
      }
    }
    // 处理关联映射文件
    this.deleteSceneBoardFormRelationMapByBundleName(bundleName);
  }

  private collectDeleteCardLayoutInfo(relationCards: CardItemInfo[], formLayoutInfo: GridLayoutItemInfo,
    deleteFormAndStackInfos: GridLayoutItemInfo[]): void {
    let index: number = relationCards.findIndex((item) => {
      return item.cardId === formLayoutInfo.cardId;
    });
    if (index !== CommonConstants.INVALID_VALUE) {
      formLayoutInfo.infoId = String(formLayoutInfo.cardId);
      deleteFormAndStackInfos.push(formLayoutInfo);
    }
  }

  private collectDeleteStackLayoutInfo(relationCards: CardItemInfo[], stackLayoutInfo: GridLayoutItemInfo,
    remainingStackInfos: GridLayoutItemInfo[], deleteFormAndStackInfos: GridLayoutItemInfo[]): void {
    let isFormStackLeft: boolean = false;
    if (!stackLayoutInfo.layoutInfo) {
      return;
    }
    for (let j = stackLayoutInfo.layoutInfo[0].length - 1; j >= 0; j--) {
      let index: number = relationCards.findIndex((item) => {
        return item.cardId === stackLayoutInfo.layoutInfo?.[0][j].cardId;
      });
      if (index !== CommonConstants.INVALID_VALUE) {
        stackLayoutInfo.layoutInfo[0][j].infoId = String(stackLayoutInfo.layoutInfo[0][j].cardId);
        deleteFormAndStackInfos.push(stackLayoutInfo.layoutInfo[0][j]);
        stackLayoutInfo.layoutInfo[0].splice(j, 1);
      } else {
        // 说明堆叠里面有其他应用卡片，保留堆叠
        isFormStackLeft = true;
      }
    }
    if (isFormStackLeft) {
      remainingStackInfos.push(stackLayoutInfo);
    } else {
      stackLayoutInfo.infoId = stackLayoutInfo.formStackId;
      deleteFormAndStackInfos.push(stackLayoutInfo);
    }
  }

  /**
   * 根据应用卡片包名修改对应卡片信息
   * 桌面进程调用函数时需要从文件中同步占位卡信息
   *
   * @param bundleName 应用包名
   * @returns 需要更新卡片的信息
   */
  public updateFormAndStackInfoByBundleName(bundleName: string, isOuter?: boolean): CardItemInfo[] {
    log.showInfo(TAG, `update the placeholder form information corresponding to the app: ${bundleName}, isOuter: ${isOuter}`);
    this.initSceneBoardFormRelation();
    if (!this.sceneBoardFormRelationModelMap.has(bundleName)) {
      log.showWarn(TAG, `the bundleName not exist:${bundleName}`);
      return [];
    }
    let relationCards: CardItemInfo[] | undefined = this.sceneBoardFormRelationModelMap.get(bundleName);
    log.showInfo(TAG, `relationCards.length: ${relationCards?.length}`);
    if (!relationCards || CheckEmptyUtils.isEmptyArr(relationCards)) {
      return [];
    }
    // 处理关联映射文件
    if (!isOuter) {
      this.deleteSceneBoardFormRelationMapByBundleName(bundleName);
    }
    return relationCards;
  }

  /**
   * 获取占位卡默认名称
   *
   * @param area 占位卡大小
   * @returns 占位卡默认名称
   */
  public getDefaultCardName(area: number[]): string {
    return SCENE_BOARD_FORM_NAME_MAP.get(this.getDefaultCardType(area)) ?? '';
  }

  private getDefaultCardType(area: number[]): number {
    if (CheckEmptyUtils.isEmpty(area) || area.length <= 1) {
      log.showError(TAG, `area is ${area}`);
      return 0;
    }
    if (area[0] === CardGridWidth_2 && area[1] === CardGridHeight_1) {
      return SCENE_BOARD_FORM_DIMENSION_2_1;
    } else if (area[0] === CardGridWidth_2 && area[1] === CardGridHeight_2) {
      return SCENE_BOARD_FORM_DIMENSION_2_2;
    } else if (area[0] === CardGridWidth_4 && area[1] === CardGridHeight_2) {
      return SCENE_BOARD_FORM_DIMENSION_2_4;
    } else if (area[0] === CardGridWidth_4 && area[1] === CardGridHeight_4) {
      return SCENE_BOARD_FORM_DIMENSION_4_4;
    } else {
      return 0;
    }
  }

  /**
   * 加载系统卡片映射表
   *
   * @param type 系统迁移或者系统迁移
   */
  public async loadFormRelation(type: string): Promise<void> {
    let config: string = '';
    try {
      config = this.getFileMapping(type);
      if (CheckEmptyUtils.checkStrIsEmpty(config)) {
        log.showWarn(TAG, `loadFormRelation from CCM: ${CONFIG}`);
        const filePath = await ConfigParseUtil.getConfig(CONFIG);
        config = fs.readTextSync(filePath);
      }
      if (CheckEmptyUtils.checkStrIsEmpty(config)) {
        log.showWarn(TAG, `loadFormRelation from CCM is empty`);
        return;
      }
      let jsonArray: Object[] = JSON.parse(config);
      if (Array.isArray(jsonArray)) {
        for (const jsonEle of jsonArray) {
          let formRelationModel: TransferFormRelationModel = new TransferFormRelationModel(jsonEle);
          this.formRelationModelMap.set(formRelationModel.fromString, formRelationModel);
        }
      }
    } catch (error) {
      log.error(TAG, 'loadFormRelation from CCM error', error);
    }
    log.showWarn(TAG, `loadFormRelation size: ${this.formRelationModelMap.size}`);
  }

  private getFileMapping(type: string): string {
    try {
      log.showInfo(TAG, `loadFormRelation from file mapping`);
      let fileMappingPath: string = '/';
      fileMappingPath = (GlobalContext.getInstance().getObject('desktopContext') as
      ctx.ServiceExtensionContext).filesDir + '/' + FORM_MAPPING_RELATION_TABLE;
      if (!FileUtils.isExist(fileMappingPath)) {
        log.showWarn(TAG, 'loadFormRelation file mapping is not exist');
        return '';
      }
      return fs.readTextSync(fileMappingPath);
    } catch (error) {
      log.error(TAG, 'loadFormRelation from file mapping error', error);
      return '';
    }
  }

  /**
   * 判断是否是SceneBoard卡片
   *
   * @param bundleName 包名
   * @param formName 卡片名称
   * @returns 是否为占位卡
   */
  public isSceneBoardCard(bundleName: string, formName: string): boolean {
    return bundleName === CommonConstants.LAUNCHER_BUNDLE &&
      Array.from(SCENE_BOARD_FORM_NAME_MAP.values()).some(val => val === formName);
  }

  /**
   * 获取占位卡信息
   *
   * @param targetFormDimension 卡片大小
   * @returns 占位卡名称
   */
  public getSceneBoardFormName(targetFormDimension: number): string {
    return SCENE_BOARD_FORM_NAME_MAP.get(targetFormDimension) ?? '';
  }

  /**
   * 获取占位卡信息
   *
   * @param bundleName 卡片包名
   * @returns 占位卡信息
   */
  public getSceneBoardFormRelationByBundleName(bundleName: string): CardItemInfo[] {
    return this.sceneBoardFormRelationModelMap.get(bundleName) ?? [];
  }

  /**
   * 设置占位卡信息
   *
   * @param bundleName 卡片包名
   * @param cardItemInfos 占位卡信息
   */
  public setSceneBoardFormRelation(bundleName: string, cardItemInfos: CardItemInfo[]): void {
    this.sceneBoardFormRelationModelMap.set(bundleName, cardItemInfos);
  }

  /**
   * 清空系统卡片映射信息
   */
  public clearFormRelationModel(): void {
    this.formRelationModelMap.clear();
  }

  /**
   * 获取系统卡片映射信息
   *
   * @param bundleName 应用包名
   * @returns 系统卡片映射信息
   */
  public getFormRelationModelMapByBundleName(bundleName: string): TransferFormRelationModel | null {
    if (this.formRelationModelMap.has(bundleName)) {
      return this.formRelationModelMap.get(bundleName) ?? null;
    }
    return null;
  }

  /**
   * 清空占位缓存信息
   */
  public clearSceneBoardFormRelationModel(): void {
    this.sceneBoardFormRelationModelMap.clear();
  }

  // 此接口只用于单元测试
  public setFormRelation(bundleName: string, model: TransferFormRelationModel): void {
    this.formRelationModelMap.set(bundleName, model);
  }

  // 此接口只用于单元测试
  public getSceneBoardFormRelationModelMap(): Map<string, CardItemInfo[]> {
    return this.sceneBoardFormRelationModelMap;
  }
}