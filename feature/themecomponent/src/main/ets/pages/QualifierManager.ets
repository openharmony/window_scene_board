/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { TWallpaperType, WallPaper, WallPaperInfo } from "@ohos/themeservicekit";
import { Log } from "../aigcServiceAbility/IdlService/Log";
import { DeviceHelper } from "../utils/DeviceHelper";
import { WallpaperQualifier, WallpaperWriter } from "../utils/WallpaperWriter";

const TAG = "QualifierManager";

export const TYPE_HOME: TWallpaperType = 'home';
export const TYPE_LOCK: TWallpaperType = 'lock';

const BASE_PATH: string = 'base'

export default class QualifierManager {
  private static sharedInstance: QualifierManager | undefined;
  public allQualifiers: WallpaperQualifier[] = [WallpaperQualifier.BASE];
  public resolutionMap: Map<number, number[]> | undefined = undefined;
  public baseDisplayWidth: number = px2vp(DeviceHelper.getDefaultDisplay()?.width ?? 0);
  public baseDisplayHeight: number = px2vp(DeviceHelper.getDefaultDisplay()?.height ?? 0);

  private _currentQualifier: WallpaperQualifier = WallpaperQualifier.BASE;
  private _tabQualifiers: WallpaperQualifier = WallpaperQualifier.BASE;
  private _existLockOrigins: WallPaper[] | undefined;
  private _existHomeOrigins: WallPaper[] | undefined;
  private _existHomeBase: WallPaper[] | undefined;
  private _existLockBase: WallPaper[] | undefined;
  private currentCallbackList: Map<string, Function> = new Map();
  private wallpaperMap: Map<WallpaperQualifier, WallpaperWriter> = new Map();

  private constructor() {
    this.allQualifiers = [WallpaperQualifier.BASE]
    this.initQualifiers();
  }

  private initQualifiers(): void {
    Log.info(TAG, 'initQualifiers');
    this.currentQualifier = WallpaperQualifier.BASE;

    this.initQualifiersDeviceSize();
  }

  static getInstance(): QualifierManager {
    if (!QualifierManager.sharedInstance){
      QualifierManager.sharedInstance = new QualifierManager();
    }
    return QualifierManager.sharedInstance
  }

  public async initQualifiersDeviceSize(): Promise<void> {
    let map: Map<number, number[]> = await DeviceHelper.getAllResolutions();
    this.resolutionMap = map;
  }

  public registerCurrentQualifierCallback(tag: string, callback: Function): void {
    this.currentCallbackList.set(tag, callback)
  }

  public getDeviceSize(qualifier: WallpaperQualifier = this.currentQualifier): number[] {
    return [this.baseDisplayWidth, this.baseDisplayHeight];
  }

  public getValidQualifiers(isTabOnly: boolean, tabQualifier: WallpaperQualifier) {
    let qualifiers: WallpaperQualifier[] = this.allQualifiers;
    return qualifiers;
  }

  public generateWallpaperInfos(isTabOnly: boolean, tabQualifier: WallpaperQualifier, params: WallpaperInfoParams[]): WallPaperInfo[] {
    if (!params || params.length !== this.allQualifiers.length) {
      Log.error(TAG, `fail generateWallpaperInfos, params.length=${params.length}, qualifiers.length=${this.allQualifiers.length}`);
      return [];
    }
    let qualifiers: WallpaperQualifier[] = this.getValidQualifiers(isTabOnly, tabQualifier);

    let homeWallpapers: WallPaper[] = [];
    let lockWallpapers: WallPaper[] = [];
    let isBaseContained: boolean = false;
    let isHomeSelected: boolean = params[0]?.isHomeSelected;
    let isLockSelected: boolean = params[0]?.isLockSelected;
    for (let i = 0; i < qualifiers.length; i++) {
      Log.info(TAG, `generateWallpaperInfos for ${qualifiers[i]}`);
      this.fillWallpaperModels(qualifiers[i], params[i].applyFrom, isTabOnly, tabQualifier);
      let writer: WallpaperWriter | undefined = this.getWallpaperWriter(qualifiers[i]);

      if (!writer) {
        Log.error(TAG, `failed to generate ${qualifiers[i]} writer`);
        continue;
      }

      if (isHomeSelected) {
        homeWallpapers = homeWallpapers.concat([writer.desktopWallpaperModel]);
      }

      if (isLockSelected) {
        lockWallpapers = lockWallpapers.concat([writer.lockWallpaperModel]);
      }

      if (qualifiers[i] === WallpaperQualifier.BASE) {
        isBaseContained = true;
      }
    }
    this.concatOrigins(homeWallpapers, tabQualifier, lockWallpapers, isHomeSelected, isLockSelected);
    let wallpaperInfos: WallPaperInfo[] = this.combineHomeLock(homeWallpapers, lockWallpapers);
    Log.info(TAG, `generateInfos done home=${homeWallpapers.length}, lock=${lockWallpapers.length}`);
    return wallpaperInfos;
  }

  private fillWallpaperModels(qualifier: WallpaperQualifier, applyFrom: string, isTabOnly: boolean, tabQualifier: WallpaperQualifier): boolean {
    let writer: WallpaperWriter | undefined = this.getWallpaperWriter(qualifier);
    if (writer === null || writer === undefined) {
      Log.info(TAG, `fillWallpaperModels writer invalid`);
      return false;
    }
    Log.info(TAG, `fill origin.src = ${writer.originWallpaperModel.src}`);

    const qualifierLower: string = qualifier.toLowerCase();
    writer.lockWallpaperModel.category = qualifierLower;
    writer.desktopWallpaperModel.category = qualifierLower;
    writer.lockWallpaperModel.applyFrom = applyFrom;
    writer.desktopWallpaperModel.applyFrom = applyFrom;
    writer.originWallpaperModel.applyFrom = applyFrom;

    return true;
  }

  private combineHomeLock(homeWallpapers: WallPaper[], lockWallpapers: WallPaper[]): WallPaperInfo[] {
    let desktopWallpaperInfo: WallPaperInfo = {
      wallPapers: homeWallpapers,
      wallPaperType: TYPE_HOME,
      type: 'image',
    };

    let lockWallpaperInfo: WallPaperInfo = {
      wallPapers: lockWallpapers,
      wallPaperType: TYPE_LOCK,
      type: 'image',
    };

    let wallpaperInfos: WallPaperInfo[] = [];
    if (desktopWallpaperInfo.wallPapers.length > 0) {
      wallpaperInfos.push(desktopWallpaperInfo);
    }

    if (lockWallpaperInfo.wallPapers.length > 0) {
      wallpaperInfos.push(lockWallpaperInfo);
    }
    return wallpaperInfos;
  }

  private concatOrigins(homeWallpapers: WallPaper[], tabQualifier: WallpaperQualifier, lockWallpapers: WallPaper[], isHomeSelected: boolean = false, isLockSelected: boolean = false): void {
    let writer: WallpaperWriter | undefined = this.getWallpaperWriter(tabQualifier);
    if (!writer) {
      Log.error(TAG, `failed to generate ${tabQualifier} writer`);
      return;
    }

    if (isHomeSelected) {
      homeWallpapers.push(writer.originWallpaperModel);
      if (this._existHomeOrigins) {
        this._existHomeOrigins.forEach((wallpaper) => {
          homeWallpapers.push(wallpaper);
        })
      }
    }

    if (isLockSelected) {
      lockWallpapers.push(writer.originWallpaperModel);
      if (this._existLockOrigins) {
        this._existLockOrigins.forEach((wallpaper) => {
          lockWallpapers.push(wallpaper)
        })
      }
    }
  }

  public generateWallpaperWriter(qualifier: WallpaperQualifier, wallpaperUrl: string): WallpaperWriter {
    Log.info(TAG, `generateWallpaperWriter ${qualifier}`);
    let desktopModel: WallPaper = new WallPaper();
    let lockModel: WallPaper = new WallPaper();
    let originModel: WallPaper = new WallPaper();
    originModel.category = BASE_PATH;

    let wallpaperWriter: WallpaperWriter = {
      qualifier: qualifier,
      desktopWallpaperModel: desktopModel,
      lockWallpaperModel: lockModel,
      originWallpaperModel: originModel,
      wallpaperUrl: wallpaperUrl,
    };
    return wallpaperWriter;
  }

  public get currentQualifier(): WallpaperQualifier {
    return this._currentQualifier;
  }

  public set currentQualifier(value: WallpaperQualifier) {
    Log.info(TAG, `currentQualifier set to ${value}`);
    if (value === this._currentQualifier) {
      return;
    }
    this._currentQualifier = value;
    this.notifyCurrentCallbacks();
  }

  public getWallpaperWriter(qualifier: WallpaperQualifier): WallpaperWriter | undefined {
    return this.wallpaperMap.get(qualifier);
  }

  public setWallpaperWriter(qualifier: WallpaperQualifier, wallpaperUrl: string): void {
    Log.info(TAG, `set WallpaperWriter ${qualifier}`);
    let writer: WallpaperWriter = this.generateWallpaperWriter(qualifier, wallpaperUrl);
    this.wallpaperMap.set(qualifier, writer)
  }

  private notifyCurrentCallbacks(): void {
    this.currentCallbackList.forEach((callback) => {
      callback();
    })
  }

  public setTabQualifier(value: WallpaperQualifier): void {
    this.currentCallbackList.forEach((callback) => {
      callback();
    })
  }
}

export interface WallpaperInfoParams {
  isLockSelected: boolean,
  isHomeSelected: boolean,
  applyFrom: string,
}