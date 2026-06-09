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

import lazy fs from '@ohos.file.fs';
import { Log } from '../utils/Log';
import { ResourceQualifierConstants } from './ResourceQualifierConstants';

const TAG: string = 'ResourceQualifierChecker';

/**
 * Helper class to check and decided which resource to use on device status change
 *
 * @since 2024-03-15
 */
export class ResourceQualifierChecker {
  private resourceRoot: string = '';

  private resourceSuffix: string = '';

  /**
   * Create a checker instance with a resource specific path provided
   *
   * @param resourceRoot Path that a resource object might be used
   * @param resourceSuffix Latter part of the path, combined with resourceRoot and qualifier would form a path
   */
  public constructor(resourceRoot: string, resourceSuffix: string) {
    this.resourceRoot = resourceRoot;
    this.resourceSuffix = resourceSuffix;
  }

  /**
   * Get the qualifier with the index provided. The index uses 3-bit integer to track three status
   *
   * @param index Numeric representative of resource qualifier
   * @returns Resource qualifier of the index. If such qualifier doesn't exist, fallback to the closest one
   */
  public getQualifierByIndex(index: number): string {
    switch (index) {
      case ResourceQualifierConstants.IDX_DEFAULT: {
        return this.getBaseQualifier();
      }
      case ResourceQualifierConstants.IDX_UNFOLDED: {
        return this.getUnfoldedQualifier();
      }
      case ResourceQualifierConstants.IDX_LAND: {
        return this.getLandQualifier();
      }
      case ResourceQualifierConstants.IDX_UNFOLDED_LAND: {
        return this.getUnfoldedLandQualifier();
      }
      case ResourceQualifierConstants.IDX_DARK: {
        return this.getDarkQualifier();
      }
      case ResourceQualifierConstants.IDX_UNFOLDED_DARK: {
        return this.getUnfoldedDarkQualifier();
      }
      case ResourceQualifierConstants.IDX_LAND_DARK: {
        return this.getLandDarkQualifier();
      }
      case ResourceQualifierConstants.IDX_UNFOLDED_LAND_DARK: {
        return this.getUnfoldedLandDarkQualifier();
      }
      case ResourceQualifierConstants.IDX_FULL_UNFOLDED: {
        return this.getFullUnfoldedQualifier();
      }
      case ResourceQualifierConstants.IDX_FULL_UNFOLDED_DARK: {
        return this.getFullUnfoldedDarkQualifier();
      }
      case ResourceQualifierConstants.IDX_FULL_UNFOLDED_LAND: {
        return this.getFullUnfoldedLandQualifier();
      }
      case ResourceQualifierConstants.IDX_FULL_UNFOLDED_LAND_DARK: {
        return this.getFullUnfoldedLandDarkQualifier();
      }
      default: {
        Log.warn(TAG, `Invalid qualifier index ${index}`);
        return this.getBaseQualifier();
      }
    }
  }

  // land->base
  private getLandQualifier(): string {
    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_LAND)) {
      return ResourceQualifierConstants.QUALIFIER_LAND;
    }
    return this.getBaseQualifier();
  }

  // unfolded->base
  private getUnfoldedQualifier(): string {
    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_UNFOLDED)) {
      return ResourceQualifierConstants.QUALIFIER_UNFOLDED;
    }
    return this.getBaseQualifier();
  }

  // unfolded_land->unfolded->land->base
  private getUnfoldedLandQualifier(): string {
    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_UNFOLDED_LAND)) {
      return ResourceQualifierConstants.QUALIFIER_UNFOLDED_LAND;
    }

    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_UNFOLDED)) {
      return ResourceQualifierConstants.QUALIFIER_UNFOLDED;
    }
    return this.getLandQualifier();
  }

  // dark->base
  private getDarkQualifier(): string {
    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_DARK)) {
      return ResourceQualifierConstants.QUALIFIER_DARK;
    }
    return this.getBaseQualifier();
  }

  // land_dark->land->dark->base
  private getLandDarkQualifier(): string {
    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_LAND_DARK)) {
      return ResourceQualifierConstants.QUALIFIER_LAND_DARK;
    }

    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_LAND)) {
      return ResourceQualifierConstants.QUALIFIER_LAND;
    }
    return this.getDarkQualifier();
  }

  // unfolded_land_dark->unfolded_land->unfolded_dark->unfolded->land_dark->land->dark->base
  private getUnfoldedLandDarkQualifier(): string {
    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_UNFOLDED_LAND_DARK)) {
      return ResourceQualifierConstants.QUALIFIER_UNFOLDED_LAND_DARK;
    }

    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_UNFOLDED_LAND)) {
      return ResourceQualifierConstants.QUALIFIER_UNFOLDED_LAND;
    }

    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_UNFOLDED_DARK)) {
      return ResourceQualifierConstants.QUALIFIER_UNFOLDED_DARK;
    }

    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_UNFOLDED)) {
      return ResourceQualifierConstants.QUALIFIER_UNFOLDED;
    }

    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_LAND_DARK)) {
      return ResourceQualifierConstants.QUALIFIER_LAND_DARK;
    }

    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_LAND)) {
      return ResourceQualifierConstants.QUALIFIER_LAND;
    }

    return this.getDarkQualifier();
  }

  // unfolded2->unfold->base
  private getFullUnfoldedQualifier(): string {
    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_FULL_UNFOLDED)) {
      return ResourceQualifierConstants.QUALIFIER_FULL_UNFOLDED;
    }

    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_UNFOLDED)) {
      return ResourceQualifierConstants.QUALIFIER_UNFOLDED;
    }
    return this.getBaseQualifier();
  }

  // unfolded2-dark->unfold2->unfold-dark->unfold->dark->base
  private getFullUnfoldedDarkQualifier(): string {
    const qualifierOrder: string[] = [
      ResourceQualifierConstants.QUALIFIER_FULL_UNFOLDED_DARK,
      ResourceQualifierConstants.QUALIFIER_FULL_UNFOLDED,
      ResourceQualifierConstants.QUALIFIER_UNFOLDED_DARK,
      ResourceQualifierConstants.QUALIFIER_UNFOLDED,
      ResourceQualifierConstants.QUALIFIER_DARK,
      ResourceQualifierConstants.QUALIFIER_BASE,
    ];
    for (const qualifier of qualifierOrder) {
      if (this.isValidFile(qualifier)) {
        return qualifier;
      }
    }
    return this.getBaseQualifier();
  }

  // unfolded2-land->unfold2->unfold-land->unfold->land->base
  private getFullUnfoldedLandQualifier(): string {
    const qualifierOrder: string[] = [
      ResourceQualifierConstants.QUALIFIER_FULL_UNFOLDED_LAND,
      ResourceQualifierConstants.QUALIFIER_FULL_UNFOLDED,
      ResourceQualifierConstants.QUALIFIER_UNFOLDED_LAND,
      ResourceQualifierConstants.QUALIFIER_UNFOLDED,
      ResourceQualifierConstants.QUALIFIER_LAND,
      ResourceQualifierConstants.QUALIFIER_BASE,
    ];
    for (const qualifier of qualifierOrder) {
      if (this.isValidFile(qualifier)) {
        return qualifier;
      }
    }
    return this.getBaseQualifier();
  }

  // unfolded2-land-dark->unfolded2-land->unfolded2-dark->unfolded2->unfolded_land_dark->unfolded_land->unfolded_dark->
  // unfolded->land_dark->land->dark->base
  private getFullUnfoldedLandDarkQualifier(): string {
    const qualifierOrder: string[] = [
      ResourceQualifierConstants.QUALIFIER_FULL_UNFOLDED_LAND_DARK,
      ResourceQualifierConstants.QUALIFIER_FULL_UNFOLDED_LAND,
      ResourceQualifierConstants.QUALIFIER_FULL_UNFOLDED_DARK,
      ResourceQualifierConstants.QUALIFIER_FULL_UNFOLDED,
      ResourceQualifierConstants.QUALIFIER_UNFOLDED_LAND_DARK,
      ResourceQualifierConstants.QUALIFIER_UNFOLDED_LAND,
      ResourceQualifierConstants.QUALIFIER_UNFOLDED_DARK,
      ResourceQualifierConstants.QUALIFIER_UNFOLDED,
      ResourceQualifierConstants.QUALIFIER_LAND_DARK,
      ResourceQualifierConstants.QUALIFIER_LAND,
      ResourceQualifierConstants.QUALIFIER_DARK,
      ResourceQualifierConstants.QUALIFIER_BASE,
    ];
    for (const qualifier of qualifierOrder) {
      if (this.isValidFile(qualifier)) {
        return qualifier;
      }
    }
    return this.getBaseQualifier();
  }

  // unfolded_dark->unfolded->dark->base
  private getUnfoldedDarkQualifier(): string {
    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_UNFOLDED_DARK)) {
      return ResourceQualifierConstants.QUALIFIER_UNFOLDED_DARK;
    }

    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_UNFOLDED)) {
      return ResourceQualifierConstants.QUALIFIER_UNFOLDED;
    }

    return this.getDarkQualifier();
  }

  private getBaseQualifier(): string {
    if (this.isValidFile(ResourceQualifierConstants.QUALIFIER_BASE)) {
      return ResourceQualifierConstants.QUALIFIER_BASE;
    }
    return '';
  }

  private isValidFile(qualifier: string): boolean {
    try {
      return fs.accessSync(`${this.resourceRoot}/${qualifier}/${this.resourceSuffix}`);
    } catch (e) {
      Log.error(TAG, `Error on getting file state ${e.code}`);
    }
    return false;
  }
}