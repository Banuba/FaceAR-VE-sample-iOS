/// \file
/// \addtogroup Types
/// @{
///
// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from types.djinni

#pragma once

#include <bnb/utils/defs.hpp>
#include <memory>
#include <vector>

namespace bnb { namespace interfaces {

enum class rotation;
struct pixel_rect;
struct point2d;

class BNB_EXPORT transformation {
public:
    virtual ~transformation() {}

    /** Constructs identity transform */
    static std::shared_ptr<transformation> make_identity();

    /** Constructs from mat_t */
    static std::shared_ptr<transformation> make_data(const std::vector<float> & mat);

    /** Constructs rotate transformation */
    static std::shared_ptr<transformation> make_rot(rotation rot);

    /** Constructs affine transformation */
    static std::shared_ptr<transformation> make_affine(float scale_x, float scale_y, float t_x, float t_y, rotation rot, bool flip_x, bool flip_y);

    /**
     * Constructs transformation from source to target rectangle
     * Rotation and flips are around rectangles' center
     */
    static std::shared_ptr<transformation> make_rects(const pixel_rect & source_rect, const pixel_rect & target_rect, rotation rot, bool flip_x, bool flip_y);

    /**
     * Applies transform t after this
     * e.g. {rotate >> translate;} rotates first: (initial -> rotated) >> (rotated -> translated) = (initial -> translated)
     */
    virtual std::shared_ptr<transformation> chain_right(const std::shared_ptr<transformation> & t) const = 0;

    /** Apply transform to point */
    virtual point2d transform_point(const point2d & p) const = 0;

    virtual pixel_rect transform_rect(const pixel_rect & rect) const = 0;

    virtual bool equals(const std::shared_ptr<transformation> & t) const = 0;

    /**
     * Get the inverse of the transformation
     * @throw std::logic_error when matrix is singular
     */
    virtual std::shared_ptr<transformation> inverse_j() const = 0;

    /** Clone the transformation */
    virtual std::shared_ptr<transformation> clone_j() const = 0;

    /** Returns 3x3 row-maj transform matrix */
    virtual std::vector<float> get_mat_j() const = 0;
};

} }  // namespace bnb::interfaces
/// @}
