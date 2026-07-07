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

import { CheckEmptyUtils, FileUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { BackupFavoriteInfo, BackupItemType } from '../../model/BackupFavoriteInfo';
import { CardTransformItem } from '../transfromitem/CardTransformItem';
import {
  CardItemInfo,
  CommonConstants,
  ConfigParseUtil,
  dataConvert,
  FormModel,
  GridLayoutItemInfo,
  SceneType
} from '../../TsIndex';
import { IntentParseUtil, PackageRelation } from '../../utils/IntentParseUtil';
import fs from '@ohos.file.fs';
import { GlobalContext } from '@ohos/frameworkwrapper';
import type ctx from '@ohos.app.ability.common';
import { ObjectCopyUtil } from '@ohos/componenthelper';

const TAG: string = 'AddCardToNewPageManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.BACKUP, TAG);
const FILE_NAME = 'add_item_hwlauncher_to_ohos.json';
const FILE_CONFIG = 'etc/clone/add_item_hwlauncher_to_ohos.json';
const FILE_CLOUD_PATH = '/data/storage/el2/backup/restore/cloudConfig/';
const ONLY_ADD = 'onlyAdd';


/**
 * 追加卡片到新机屏
 */
export class AddCardToNewPageManager extends CardTransformItem {
  private static instance: AddCardToNewPageManager;
  private sceneType: number = SceneType.FROM_SCENE_BOARD;
  private mappingMap: Map<string, CardMappingModel> = new Map();
  private mappingSet: Set<CardMappingModel> = new Set();
  private todoList: AddCardToNewPageModel[] = [];

  static getInstance(): AddCardToNewPageManager {
    if (AddCardToNewPageManager.instance == null) {
      let favoriteInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
      AddCardToNewPageManager.instance = new AddCardToNewPageManager(favoriteInfo);
    }
    return AddCardToNewPageManager.instance;
  }

  /**
   * 初始化
   *
   * @param sceneType 场景
   */
  public async init(sceneType: number): Promise<void> {
    this.sceneType = sceneType;
    this.todoList = [];
    this.mappingMap = new Map();
    this.mappingSet = new Set();
    await this.loadFileMapping();
    log.showWarn(`init sceneType: ${this.sceneType}, mappingMap: ${this.mappingMap.size}, mappingSet: ${this.mappingSet.size}`);
  }

  /**
   * 加载CCM上追加卡片的映射表
   */
  private async loadFileMapping(): Promise<void> {
    let config: string = '';
    try {
      config = this.getFileMapping();
      if (CheckEmptyUtils.checkStrIsEmpty(config)) {
        const filePath: string = await ConfigParseUtil.getConfig(FILE_CONFIG);
        config = fs.readTextSync(filePath);
      }
      this.parseFileMapping(config);
    } catch (error) {
      log.error('loadFileMapping from CCM error', error);
    }
  }

  private getFileMapping(): string {
    try {
      let fileMappingPath: string = '/';
      if (this.sceneType === SceneType.FROM_HW_LAUNCHER) {
        fileMappingPath = FILE_CLOUD_PATH + FILE_NAME;
      } else {
        fileMappingPath = (GlobalContext.getInstance().getObject('desktopContext') as
        ctx.ServiceExtensionContext).filesDir + '/' + FILE_NAME;
      }
      if (!FileUtils.isExist(fileMappingPath)) {
        log.showWarn('loadFileMapping file mapping is not exist');
        return '';
      }
      return fs.readTextSync(fileMappingPath);
    } catch (error) {
      log.error('loadFileMapping from file mapping error', error);
      return '';
    }
  }

  private parseFileMapping(config: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(config)) {
      log.showWarn(`loadFileMapping from CCM is empty`);
      return;
    }
    let jsonArray: Object[] = JSON.parse(config);
    if (Array.isArray(jsonArray)) {
      for (const jsonEle of jsonArray) {
        let mapping: CardMappingModel = new CardMappingModel(jsonEle);
        let sceneTypes: string[] = mapping.sceneType.split(',');
        if (sceneTypes.indexOf(this.sceneType.toString()) === CommonConstants.INVALID_VALUE) {
          continue;
        }
        log.showWarn(`parse file mapping mapKey: ${mapping.mapKey}, ${mapping.targetBundleName}, ${mapping.targetCardName},` +
          ` ${mapping.targetCardUnique}`);
        if (mapping.sourceAbilityName === ONLY_ADD) {
          this.mappingSet.add(mapping);
        } else {
          this.mappingMap.set(mapping.mapKey, mapping);
        }
      }
    }
  }

  /**
   * 处理追加卡片
   *
   * @param backupItem  待插入恢复列表的卡片集合
   */
  public async dealWithAddCard(backupItem: GridLayoutItemInfo[]): Promise<void> {
    if (this.sceneType === SceneType.FROM_SCENE_BOARD) {
      return;
    }
    const length: number = backupItem.length;
    for (const item of this.todoList) {
      await this.addCardToNewPage(backupItem, item.backupInfo, item.mapping);
    }
    for (const mapping of this.mappingSet) {
      await this.addCardToNewPage(backupItem, new BackupFavoriteInfo(), mapping);
    }
    log.showWarn(`dealWithTodoList sceneType: ${this.sceneType}, ${length} -> ${backupItem.length}`);
  }

  private async addCardToNewPage(backupItem: GridLayoutItemInfo[], backupInfo: BackupFavoriteInfo,
    mapping: CardMappingModel): Promise<void> {
    try {
      if (mapping.targetCardUnique !== CardUniqueType.NOTHING &&
      backupItem.some(item => this.isMappingCard(item, mapping))) {
        log.showWarn(`addCardToNewPage return mapping: ${mapping.targetBundleName}, ${mapping.targetCardName}, ${mapping.targetCardUnique}`);
        return;
      }
      const cards: CardItemInfo[] = await FormModel.getInstance().getFormsInfoByBundleName(mapping.targetBundleName);
      let cardItem: CardItemInfo = cards?.find(item => item.cardName === mapping.targetCardName) as CardItemInfo;
      if (CheckEmptyUtils.isEmpty(cardItem)) {
        log.showWarn(`addCardToNewPage empty length: ${cards.length}, targetCardName: ${mapping.targetCardName}`);
        return;
      }
    } catch (error) {
      log.error('addCardToNewPage error', error);
    }
  }

  /**
   * CCM配置的去重规则
   */
  private isMappingCard(item: GridLayoutItemInfo, mapping: CardMappingModel): boolean {
    if (mapping.targetCardUnique === CardUniqueType.BUNDLE_NAME) {
      return item.typeId === CommonConstants.TYPE_CARD && item.bundleName === mapping.targetBundleName;
    }
    return item.typeId === CommonConstants.TYPE_CARD && item.bundleName === mapping.targetBundleName &&
      item.cardName === mapping.targetCardName;
  }

  /**
   * （快捷方式）追加到新机屏
   *
   * @param backupInfo 设备数据库info
   */
  public addCardToNewPageShortcut(backupInfo: BackupFavoriteInfo): void {
    if (!backupInfo) {
      log.showWarn('backupInfo is null');
      return;
    }
    if (backupInfo.itemType === BackupItemType.BACKUP_ITEM_TYPE_SHORTCUT) {
      let packageRelation: PackageRelation | null = IntentParseUtil.getComponentByIntent(backupInfo.intent);
      if (!packageRelation) {
        return;
      }
      this.isMapKey(backupInfo, packageRelation.className);
    }
  }

  /**
   * （应用）追加到新机屏
   *
   * @param backupInfo 设备数据库info
   * @param packageRelation 映射关系
   */
  public addCardToNewPageApp(backupInfo: BackupFavoriteInfo, packageRelation: PackageRelation): void {
    if (backupInfo.itemType === BackupItemType.BACKUP_ITEM_TYPE_APP) {
      this.isMapKey(backupInfo, packageRelation.className);
    }
  }

  /**
   * （卡片）追加到新机屏
   *
   * @param backupInfo 设备数据库info
   * @param formRelationParamStr 映射关系唯一字串
   */
  public addCardToNewPageCard(backupInfo: BackupFavoriteInfo, formRelationParamStr: string): void {
    if (backupInfo.itemType === BackupItemType.BACKUP_ITEM_TYPE_CARD) {
      // 两种配置互不影响：先做系统的卡片映射,再做卡片追加
      this.isMapKey(backupInfo, formRelationParamStr);
    }
  }

  private isMapKey(backupInfo: BackupFavoriteInfo, key: string): void {
    const mapKey: string = backupInfo.itemType + ':' + key;
    if (this.mappingMap.has(mapKey)) {
      log.showWarn(`isMapKey mapKey true: ${mapKey}`);
      let mapping: CardMappingModel = this.mappingMap.get(mapKey) as CardMappingModel;
      let info: AddCardToNewPageModel = new AddCardToNewPageModel(backupInfo, mapping);
      this.todoList.push(info);
    } else {
      log.showDebug(`isMapKey mapKey false: ${mapKey}`);
    }
  }

  /**
   * 获取映射关系唯一字串
   * @param intent 设备数据库intent字段
   * @returns 卡片映射关系唯一字串
   */
  public getFormRelationParamsFromIntent(intent: string): string {
    return super.getFormRelationParamsFromIntent(intent);
  }
}

/**
 * 卡片映射model
 */
export class CardMappingModel {
  // 场景类型
  public sceneType: string = SceneType.FROM_SCENE_BOARD.toString();

  // 0-APP； 7-快捷方式； 9-卡片
  public sourceType: number = 9;

  // get from intent > component
  public sourceBundleName: string = '';

  // ohos.extra.param.key.module_name
  public sourceModuleName: string = '';

  // get from intent > component
  public sourceAbilityName: string = '';

  // ohos.extra.param.key.form_name
  public sourceFormName: string = '';

  // card dimension,ohos.extra.param.key.form_dimension，use 1,2,3,4 1->2x1,2->2x2,3->2x4，4->4x4
  public sourceFormDimension: number = 1;

  // 设备卡片的BundleName
  public targetBundleName: string = '';

  // 设备卡片的CardName
  public targetCardName: string = '';

  // 设备卡片去重逻辑：   0-不去重；1-按照targetBundleName去重； 2-按照targetBundleName+targetCardName去重
  public targetCardUnique: CardUniqueType = 2;

  // Map中的key
  public mapKey: string = '';

  constructor(jsonObj: Object) {
    ObjectCopyUtil.simpleClone(jsonObj, this);
    if (this.sourceType === BackupItemType.BACKUP_ITEM_TYPE_CARD) {
      this.mapKey =
        this.sourceType + ':' + this.sourceBundleName + ':' + this.sourceModuleName + ':' + this.sourceAbilityName +
          ':' + this.sourceFormName + ':' + this.sourceFormDimension;
    } else {
      this.mapKey = this.sourceType + ':' + this.sourceAbilityName;
    }
  }
}

/**
 * 追加卡片到新机屏model
 */
export class AddCardToNewPageModel {
  // 设备数据库info
  public backupInfo: BackupFavoriteInfo;

  // 卡片映射
  public mapping: CardMappingModel;

  constructor(backupInfo: BackupFavoriteInfo, mapping: CardMappingModel) {
    this.backupInfo = backupInfo;
    this.mapping = mapping;
  }
}

/**
 * 卡片去重类型
 */
export enum CardUniqueType {
  /**
   * 不去重
   */
  NOTHING = 0,
  /**
   * 按照targetBundleName去重
   */
  BUNDLE_NAME = 1,

  /**
   * 按照targetBundleName+targetCardName去重
   */
  BUNDLE_NAME_CARD_NAME = 2,
}