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
import { CommonConstants, DesktopLayoutState } from '../constants/CommonConstants';
import { FormManager } from '../manager/FormManager';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  FileUtils,
  SingleBase,
  singleManager,
  SingleContext,
  CommonUtils
} from '@ohos/basicutils';
import { GlobalContext, DeviceHelper } from '@ohos/frameworkwrapper';
import type DefaultDesktopLayoutInfo from '../configs/DefaultDesktopLayoutInfo';
import ConfigParseUtil from '../utils/ConfigParseUtil';
import util from '@ohos.util';
import { InstructionManager } from '../utils/differential/InstructionManager';
import type ctx from '@ohos.app.ability.common';
import { AppCategoryInfoManager } from '../manager/AppCategoryInfoManager';

const TAG = 'GetLayoutInfoFromConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 通过配置文件获取布局数据
 */
export class GetLayoutInfoFromConfig extends SingleBase {
  public static singleName: string = 'GetLayoutInfoFromConfig';
  private mFinalLayout: DefaultDesktopLayoutInfo | null = null;
  private mOuterFinalLayout: DefaultDesktopLayoutInfo | null = null;
  private mSimpleFinalLayout: DefaultDesktopLayoutInfo | null = null;

  private mGetLayoutInfoCallbacks: Array<Function> = [];
  // 获取预制布局是否完成
  private isFinishedFlag: boolean = false;

  static getInstance(ctx?: SingleContext): GetLayoutInfoFromConfig {
    return singleManager.get<GetLayoutInfoFromConfig>(GetLayoutInfoFromConfig, ctx);
  }

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  /**
   * 对于获取布局信息注册callback，当第一次读取到了布局信息就通知其他注册处，避免多次读取
   *
   * @param callback 注册获取布局信息回调
   */
  public registerGetLayoutInfoCallback(callback: Function): void {
    log.info('ready to registerGetLayoutInfoCallback');
    if (!this.isFinishedFlag) {
      log.showInfo('Loading the layout configuration file is not complete, registerGetLayoutInfoCallback start.');
      this.mGetLayoutInfoCallbacks.push(callback);
    } else {
      log.showInfo('Loading the layout configuration file is complete, The operation is performed directly.');
      callback();
    }
  }

  /**
   * 清空mFinalLayout
   *
   */
  public clearFinalLayout(): void {
    if (this.mFinalLayout != null) {
      this.mFinalLayout = null;
      this.mSimpleFinalLayout = null;
      this.isFinishedFlag = false;
      log.showInfo('GetLayoutInfoFromConfig mFinalLayout has been cleared');
    }
    if (this.mOuterFinalLayout != null) {
      this.mOuterFinalLayout = null;
      log.showInfo('GetLayoutInfoFromConfig mOuterFinalLayout has been cleared');
    }
  }


  /**
   * 通过配置文件获取简易桌面布局
   *
   * @returns
   */
  public async getSimpleLayoutConfigFile(): Promise<DefaultDesktopLayoutInfo> {
    log.info('getSimpleLayoutConfigFile -> start.');
    if (this.mSimpleFinalLayout != null) {
      return this.mSimpleFinalLayout;
    }

    let fileName: string = 'simple_layoutInfo.json';
    this.mSimpleFinalLayout = await this.getConfigFromFile(fileName) as DefaultDesktopLayoutInfo;
    this.complementaryLayoutInfo(this.mSimpleFinalLayout);
    this.isFinishedFlag = true;
    this.mGetLayoutInfoCallbacks.forEach((callback: Function) => {
      if (callback) {
        callback();
      }
    });
    this.mGetLayoutInfoCallbacks = [];

    log.showInfo(`getSimpleLayoutConfigFile end,finalLayout.layoutInfo.length ${this.mSimpleFinalLayout?.layoutInfo.length}`);
    return this.mSimpleFinalLayout;
  }

  /**
   * 通过配置文件获取布局信息
   *
   * @returns 布局信息
   */
  public async getAllLayoutConfigFile(filePath?: string): Promise<DefaultDesktopLayoutInfo> {
    log.info('getAllLayoutConfigFile -> start.');
    if (this.mFinalLayout != null && !filePath) {
      log.showInfo('mFinalLayout is not null');
      return this.mFinalLayout;
    }
    let cfgFiles: string[] = [];
    let configPath: string = 'etc/openharmony_launcher_default_workspace.json';
    try {
      cfgFiles = await ConfigParseUtil.getAllConfig(configPath);
    } catch (error) {
      log.error('configPolicy.getCfgFiles error', error);
    }
    if (filePath) {
      // 只获取定制目录下的布局信息
      cfgFiles = [];
      cfgFiles.push(filePath);
    }
    if (CheckEmptyUtils.isEmptyArr(cfgFiles)) {
      log.showWarn('getAllLayoutConfigFile -> cfgFiles is empty.');
      this.mFinalLayout = await this.getConfigFromFile((DeviceHelper.isPhone() || DeviceHelper.isPC()) ?
        'layoutInfo.json' : 'layoutInfo_pad.json');
    } else {
      this.configLisTraversal(cfgFiles);
    }

    this.isFinishedFlag = true;
    this.mGetLayoutInfoCallbacks.forEach((callback: Function) => {
      if (callback) {
        callback();
      }
    });
    this.mGetLayoutInfoCallbacks = [];

    log.showInfo(`getAllLayOutConfigFile end,finalLayout.layoutInfo.length ${this.mFinalLayout?.layoutInfo.length} `);
    return this.mFinalLayout as DefaultDesktopLayoutInfo;
  }

  /**
   * 通过配置文件获取pc/pad 2in1下的pc模式桌面布局
   *
   * @returns 布局信息
   */
  public async get2in1PcLayoutConfigFile(filePath?: string): Promise<DefaultDesktopLayoutInfo> {
    log.info('get2in1PcLayoutConfigFile -> start.');
    if (this.mFinalLayout != null && !filePath) {
      log.showInfo('mFinalLayout is not null');
      return this.mFinalLayout;
    }
    let cfgFiles: string[] = [];
    let configPath: string = 'etc/openharmony_launcher_2in1_pc_workspace.json';
    try {
      cfgFiles = await ConfigParseUtil.getAllConfig(configPath);
    } catch (error) {
      log.error('configPolicy.getCfgFiles error', error);
    }
    if (filePath) {
      // 只获取定制目录下的布局信息
      cfgFiles = [];
      cfgFiles.push(filePath);
    }
    if (CheckEmptyUtils.isEmptyArr(cfgFiles)) {
      log.showError('get2in1PcLayoutConfigFile -> cfgFiles is empty.');
      this.mFinalLayout = await this.getConfigFromFile(DeviceHelper.is2In1DevicePcType() ?
        'layoutInfo_pc_mode.json' : 'layoutInfo.json');
    } else {
      this.configLisTraversal(cfgFiles);
    }
    this.isFinishedFlag = true;
    this.mGetLayoutInfoCallbacks.forEach((callback: Function) => {
      if (callback) {
        callback();
      }
    });
    this.mGetLayoutInfoCallbacks = [];
    log.showInfo(`get2in1PcLayoutConfigFile end,finalLayout.layoutInfo.length ${this.mFinalLayout?.layoutInfo.length} `);
    return this.mFinalLayout as DefaultDesktopLayoutInfo;
  }

  public getOuterLayoutConfigFile(): DefaultDesktopLayoutInfo | null {
    log.showInfo(`getOuterLayOutConfigFile end,finalLayout.layoutInfo.length ${this.mOuterFinalLayout?.layoutInfo.length} `);
    return this.mOuterFinalLayout;
  }

  private configLisTraversal(cfgFiles: string[]): void {
    let configList: Array<DefaultDesktopLayoutInfo> = [];
    cfgFiles.forEach((filePath) => {
      log.showInfo('Succeeded in obtaining the CCM layout configuration file.');
      const layout: DefaultDesktopLayoutInfo = FileUtils.readJsonFile(filePath.toString());
      this.complementaryLayoutInfo(layout);
      configList.push(layout);
    });
    if (configList.length > 0) {
      let isNotEmpt = AppCategoryInfoManager.getInstance().isPresetMapNotEmpt();
      log.info(`configLisTraversal Start solving CCM appCatagory ${isNotEmpt}`);
      if (!isNotEmpt) {
        AppCategoryInfoManager.getInstance().initPresetAppCatIdMap(configList);
      }
    }
    if (configList.length === 1) {
      this.mFinalLayout = configList[0];
    }
    if (configList.length > 1) {
      this.mFinalLayout = configList[0];
      for (let index = 1; index < configList.length; index++) {
        this.mFinalLayout = this.mergeLayout(this.mFinalLayout, configList[index]);
      }
    }
  }

  private async getConfigFromFile(fileName: string): Promise<DefaultDesktopLayoutInfo | null> {
    let defaultConfig: DefaultDesktopLayoutInfo | null = null;
    try {
      await (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).resourceManager
        .getRawFileContent(fileName).then(value => {
          let textDecoder = new util.TextDecoder('utf-8', { ignoreBOM: true });
          const configFromFile = textDecoder.decodeWithStream(value, { stream: false });
          if (configFromFile) {
            defaultConfig = JSON.parse(configFromFile);
          }
          return defaultConfig;
        }).catch((error: Error) => {
          log.showError(`getRawFileContent promise error, message: ${error.message}.`);
        });
    } catch (error) {
      log.showError(`promise getRawFileContent failed, error code: ${error.code}, message: ${error.message}.`);
    }
    return defaultConfig;
  }

  private mergeLayout(oriLayout: DefaultDesktopLayoutInfo, incLayout: DefaultDesktopLayoutInfo):
    DefaultDesktopLayoutInfo {
    if (!CheckEmptyUtils.isEmpty(incLayout.layoutInfo)) {
      if (!CheckEmptyUtils.isEmpty(incLayout.layoutDescription)) {
        oriLayout.layoutDescription = incLayout.layoutDescription;
      }
      if (CheckEmptyUtils.isEmpty(oriLayout.layoutInfo)) {
        oriLayout.layoutInfo = incLayout.layoutInfo;
      } else {
        for (let index = 0; index < incLayout.layoutInfo.length; index++) {
          let gridLayout = incLayout.layoutInfo[index];
          const op = gridLayout.operation?.toString();
          oriLayout.layoutInfo = InstructionManager.getInstance().executeCommand(op, oriLayout.layoutInfo, gridLayout);
        }
      }
    }
    return oriLayout;
  }

  /**
   * 对布局信息进行补全，主要的功能：对于工作区的app，如果没有area属性，默认为[1,1],文件夹默认为[2,2],卡片的area根据卡片的cardDimension进行映射
   * @param gridInfo 待补全的布局信息
   */
  private complementaryLayoutInfo(gridInfo: DefaultDesktopLayoutInfo | null): void {
    if (gridInfo && !CheckEmptyUtils.isEmptyArr(gridInfo.layoutInfo)) {
      gridInfo.layoutInfo.forEach(item => {
        if (item.typeId === CommonConstants.TYPE_CARD) {
          if (item.area === undefined) {
            item.area = FormManager.getInstance().getCardSize(item.cardDimension ?? 0);
          }
          item.cardId = '';
          item.appIconId = 0;
        } else if (item.typeId === CommonConstants.TYPE_APP) {
          item.appIndex = 0;
        }
        if (item.area === undefined) {
          item.area = [1, 1];
        }
        if (item.typeId === CommonConstants.TYPE_FOLDER) {
          item.bundleName = item.folderId ?? '';
          item.keyName = item.folderId;
          item.appIconId = 0;
        }
      });
    } else {
      log.showInfo('gridInfo.layoutInfo is empty!');
    }
  }

  public async getOuterAllLayoutConfigFile(): Promise<DefaultDesktopLayoutInfo | null> {
    if (this.mOuterFinalLayout != null) {
      log.showInfo('mOuterFinalLayout is not null');
      return this.mOuterFinalLayout;
    }
    return null;
  }
}