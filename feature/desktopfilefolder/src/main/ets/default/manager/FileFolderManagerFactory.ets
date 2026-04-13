/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import type FileFolderManager from './FileFolderManager';

const TAG = 'FileFolderManagerFactory';

class FileFolderManagerFactory {
  private static instance: FileFolderManagerFactory;
  private fileFolderManager?: FileFolderManager;

  private constructor() {
  }

  static getInstance(): FileFolderManagerFactory {
    if (!FileFolderManagerFactory.instance) {
      FileFolderManagerFactory.instance = new FileFolderManagerFactory();
    }
    return FileFolderManagerFactory.instance;
  }

  setFileFolderManager(fileFolderManager: FileFolderManager): void {
    console.info(`wang setFileFolderManager ${fileFolderManager}`);
    this.fileFolderManager = fileFolderManager;
  }

  getFileFolderManager(): FileFolderManager {
    return this.fileFolderManager as FileFolderManager;
  }
}

const fileFolderManagerFactory = FileFolderManagerFactory.getInstance();
export default fileFolderManagerFactory;