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
import { LegacyInfo } from '../constants/CommonConstants';

/**
 *  恢复启动程序数据合集信息
 */
export class RestoreLauncherDataListInfo {
  public pkgList: string[] = [];
  public bundleList: string[] = [];
  public iconUriList: string[] = [];
  public titleList: string[] = [];
  public ownerInfo?: string[] = [];
  public legacyInfoList: LegacyInfo[] = [];
  public appTypeList: number[] = [];
  public enterpriseLinkList: string[] = [];
  public isWaitForHarmonyList: boolean[] = [];
  public waitForSystemKeyList: string[] = [];
  public appIndexList: number[] = [];
  public callerName: string = '';
  public isBackUpLauncherLayout: boolean = false;
  public isInContainerList: boolean[] = [];
}