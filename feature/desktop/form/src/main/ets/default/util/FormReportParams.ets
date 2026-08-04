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

/**
 * 卡片点击、卡片刷新等事件上报,卡片周期上报
 *
 * @since 2023-12-26
 */

export class FormWeeklyParams {
  // 进程包名
  public PNAMEID: string = '';

  // 进程名
  public PVERSIONID: string = '';

  // 桌面添加的应用数量
  public APPNUM: number = -1;

  // 支持卡片的应用数量
  public SUPAPP: number = -1;

  // 桌面卡片数量
  public FANUM: number = -1;

  // 包名
  public PACKAGENAME: string = '';

  // 应用模块名
  public MODULENAME: string = '';

  // 卡片尺寸类型 spanX*spanY
  public CELLSIZE: string = '';

  // 卡片具体尺寸width*height
  public DPSIZE: string = '';

  // 卡片唯一标识
  public FORMID: string = '';

  // 卡片名称
  public FORMNAME: string = '';

  // 卡片所在屏幕ID
  public SCREENID: string = '';

  // 卡片所在行
  public CELLX: number = -1;

  // 卡片所在列
  public CELLY: number = -1;

  // 上报批次标识,同一批次标识相同
  public SERIALNUM: string = '';

  // 预置卡片数
  public PRESETSNUM: number = -1;

  // 系统迁移替换卡片数
  public UPGRADENUM: number = -1;

  // 卡片来源
  public SOURCETYPE: string = '';

  // 卡片类型，0-普通卡片 1-互动卡片-场景动效 2-互动卡片-趣味交互
  public FORMTYPE: number = -1;
}

export class FormExposureParams {
  // 进程包名
  public PNAMEID: string = '';

  // 进程名
  public PVERSIONID: string = '';

  // 卡片包名
  public BUNDLENAME: string = '';

  // 卡片名称
  public ABILITYNAME: string = '';

  // 卡片模块名称
  public MODULENAME: string = '';

  // 卡片类型名称
  public FORMNAME: string = '';

  // 卡片唯一标识
  public FORMID: string = '';

  // 卡片类型，0-普通卡片 1-互动卡片-场景动效 2-互动卡片-趣味交互
  public FORMTYPE: number = -1;

  // 卡片在第几屏 currentScreen/totalScreen
  public PAGE: string = '';

  // 卡片尺寸 例:2*4
  public SIZE: string = '';

  // 卡片所在行
  public CELLX: number = -1;

  // 卡片所在行列
  public CELLY: number = -1;

  // 卡片一次打点的曝光总次数；一般是30，若在未满30次时删除，上报次数小于30
  public TOTALCOUNT: number = -1;

  // 卡片一次打点的曝光总时长(ms)
  public TOTALTIME: number = -1;

  // 卡片曝光次数及时长[{startT1 + endT1}, {startT2 + endT2}...]
  public TIME: string = '';
}

export class FormParams {
  public PNAMEID: string = '';
  public PVERSIONID: string = '';
  public PACKAGENAME: string = '';
  public PKG: string = '';
  public COMPONENTNAME: string = '';
  public FORMID: string = '';
  public FORMNAME: string = '';
  public MODULENAME: string = '';
  public DEVICETYPE: number = -1;
  public ROTATIONMODE: number = -1;
  public INTOCARDTYPE: string = '';
  public SIZE: string = '';
  public VERSIONCODE: string = '';
  public DEVICE_TYPE?: number;
  public ROTATION_MODE?: number;
  public FORM_ID: string = '';
  public MODULE_NAME: string = '';
  public FORM_NAME: string = '';
  public CELL_SIZE: string = '';
  public ITEM_TYPE: number = -1;
}