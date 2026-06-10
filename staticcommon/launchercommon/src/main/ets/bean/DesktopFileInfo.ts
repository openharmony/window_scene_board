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

export class DesktopFileInfo {
  /**
   * Indicates the path of the file.
   */
  public uri: string = '';

  /**
   * Indicates the relativePath of the file.
   */
  public relativePath?: string = '';

  /**
   * Indicates the name of the file.
   */
  public fileName?: string = '';

  /**
   * Indicates the size of the file.
   */
  public size?: number = -1;

  /**
   * Indicates the mtime of the file.
   */
  public mtime?: number = -1;

  /**
   * Indicates the mimeType of the file.
   */
  public mimeType?: string = '';

  /**
   * Indicates the thumbnail of file
   */
  public thumbnail?: number;

  /**
   * Indicates the Unique Identifier of the file,
   */
  public ino?: string;

  /**
   * Indicates the type of file
   */
  public fileType?: number;

  /**
   * Indicates the ctime of the file.
   */
  public ctime?: number = -1;

  /**
   * new file column
   */
  public column?: number;

  /**
   * new file row
   */
  public row?: number;

  /**
   * new file page
   */
  public page?: number;
}

export enum FileType {
  TYPE_FOLDER = 0,
  TYPE_FILE
}