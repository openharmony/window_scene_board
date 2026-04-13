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


/**
 * Item info of desktop right click submenu.
 */
export class RightMenuNewFileData {

  /**
   * 包名
   */
  public bundleName: string = '';

  /**
   * 模块名
   */
  public moduleName: string = '';

  /**
   * 菜单名
   */
  public menuName: string = '';

  /**
   * 文件后缀
   */
  public fileSuffix: string = '';

  /**
   * 文件模板路径
   */
  public templatePath: string = '';

  /**
   * 图标路径
   */
  public iconPath: string = '';
}


export class MenuClickModel {
  /**
   * click事件是否被拦截
   */
  public isClickIntercepted: boolean = false;

  /**
   * 桌面实际响应click的页索引值
   */
  public responseClickPageIndex: number = 0;
}
